require 'rake'

namespace :run do 
  namespace :app do
    desc 'Run application via rack'
    task :rack do
      `rackup`
    end
    
    desc 'Run application via thin'
    task :thin do 
    end
  end
  
  desc 'Run messaging server'
  task :messaging_server do 
    `./lib/messaging_server`
  end
  
  task :ms => :messaging_server
end
