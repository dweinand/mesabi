require 'rubygems'
require 'rack'
require 'thin'

class Hello
  
  def call(env)
    [200, {'content_type' => 'text/plain'}, ['Hello World']]
  end
  
end

Rack::Handler::Thin.run(Hello.new)