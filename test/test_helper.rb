require 'test/unit'
require 'rubygems'
require 'shoulda'
require 'benchmark'
require File.join(File.dirname(__FILE__), '../lib/mesabi')

class Test::Unit::TestCase
  
  def mock_env(uri)
    Rack::MockRequest.env_for(uri)
  end
  
  class << self
    
  end
  
end