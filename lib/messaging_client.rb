require 'drb'
require 'forwardable'

class Client
  extend Forwardable
  
  def initialize(port)
    @storage = DRbObject.new nil, "druby://localhost:#{port}"
  end
  
  def_delegators :@storage, :create_room, :add, :get_last, :remove_room
end
