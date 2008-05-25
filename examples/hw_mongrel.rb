require File.join(File.dirname(__FILE__), '..', 'lib', 'mesabi')
require 'mongrel'

module HW
  
  class Hello < Mesabi::Controller
    
    def index
      'Hello World'
    end
    
  end
  
  class Application < Mesabi::Application
    
  end
  
end

app = HW::Application.new
app.build_routes do |r|
  r.home('/', {'controller' => 'hello', 'action' => 'index'}) 
end

Rack::Handler::Mongrel.run(app)