require File.join(File.dirname(__FILE__), '..', 'lib', 'mesabi')
require 'thin'

module Duluth
  
  class People
    
    attr_accessor :request
    
    def initialize(request)
      self.request = request
    end
    
    def run(action)
      send(action)
    end
    
    def index
      [200, {'content_type' => 'text/plain'}, [request.params.inspect]]
    end
    
  end
  
  class Application < Mesabi::Application
    
  end
  
end

app = Duluth::Application.new
app.build_routes do |r|
  r.home('/', {'controller' => 'home', 'action' => 'index'}) 
  r.chunky('/chunky/:action', {'controller' => 'chunky'})
  r.bacon('/bacon/chunky/:id', {'controller' => 'bacon', 'action' => 'chunky'})
  r.people('/people', {'controller' => 'people', 'action' => 'index'})
  r.match('/:controller/:action/:id')
end

Rack::Handler::Thin.run(Rack::ShowExceptions.new(app))