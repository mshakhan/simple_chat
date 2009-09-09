APP_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))

require 'rubygems'
require 'sinatra'
require 'haml'
require 'erb'
require 'sass'
require 'json'

require 'storage'
require 'messaging_client'

class App < Sinatra::Application
  set :root, APP_ROOT  
  set :config, YAML::load(File.read(File.join(APP_ROOT, 'config.yml')))
  set :client, Client.new(self.config['messaging_port'])
  
  get '/' do
    redirect "/room/#{client.create_room}"
  end
  
  get '/room/:room_id' do |room_id|
    haml :index, :locals => { :room_id => room_id }
  end
  
  get '/unauthorized' do
    haml :unauthorized, :locals => { :back => params[:back] }
  end
  
  get '/destroy_room/:room_id' do |room_id|
    client.remove_room(room_id)
    render_json :ok => true    
  end
  
  get '/last' do
    room_id = params[:room_id]
    user    = params[:user]
    last_time = 0
    last_time = params[:last_time].to_i if params[:last_time]
    last = client.get_last(room_id, user, last_time)
    if last
      render_json last
    else
      render_json :error => 'no_such_room'
    end
  end
  
  get '/layout.css' do
    content_type 'text/css'
    sass :layout
  end
  
  post '/add' do
    room_id = params[:room_id]
    user    = params[:user]
    message = params[:message]
    if client.add(room_id, user, message)
      render_json :ok => true
    else
      render_json :error => 'no_such_room'
    end
  end
  
  helpers do 
    def render_json(value)
      content_type :json
      value.to_json
    end
    
    def css(path)
      %{<link rel="stylesheet" href="/#{path}.css" type="text/css" />}
    end
    
    def js(path = nil, &block)
      if block_given?
        %{<script type="text/javascript">\n  #{capture_haml(&block)}</script>}
      else
        %{<script type="text/javascript" src="/#{path}.js"></script>}
      end
    end
    
    def title
      'Simple Chat'
    end
  end
  
  private  
  def client
    self.class.client
  end    
end

