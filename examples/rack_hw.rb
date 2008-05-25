require 'rubygems'
require 'rack'
require 'mongrel'

class Hello
  
  def call(env)
    [200, {'content_type' => 'text/plain'}, ['Hello World']]
  end
  
end

Rack::Handler::Mongrel.run(Hello.new)