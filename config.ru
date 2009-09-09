# To use with thin 
#  thin start -p PORT -R config.ru

$LOAD_PATH.unshift File.join(File.expand_path(File.dirname(__FILE__)), 'lib')
require 'app'

disable :run
set :environment, :production
run App
