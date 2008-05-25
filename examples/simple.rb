require File.join(File.dirname(__FILE__), '..', 'lib', 'mesabi')
require 'thin'

app = Mesabi::Application.new
app.build_routes do |r|
  r.home('/', {'controller' => 'home', 'action' => 'index'}) 
  r.chunky('/chunky/:action', {'controller' => 'chunky'})
  r.bacon('/bacon/chunky/:id', {'controller' => 'bacon', 'action' => 'chunky'})
  r.match('/:controller/:action/:id')
end

Rack::Handler::Thin.run(Rack::ShowExceptions.new(app))