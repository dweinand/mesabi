require File.join(File.dirname(__FILE__), '../test_helper')

module Mesabi
  
  class RouteTest < Test::Unit::TestCase
    
    context "A route" do
      
      setup do
        @route = Route.new('/people/:id.:format', 'controller' => 'people', 'action' => 'show')
        @other_route = Route.new('/people', 'controller' => 'people', 'action' => 'index')
      end

      should "construct proper regular expression" do
        assert_equal %r(^/people/([^\/;.,?]+)\.([^\/;.,?]+)/?$), @route.regexp
      end
      
      should "recognize properly formatted request path" do
        assert_equal({'controller' => 'people', 'action' => 'show', 'id' => '1', 'format' => 'txt'},
          @route.recognize('/people/1.txt'))
      end
      
      should "not recognize improperly formatted request path" do
        assert_nil @route.recognize('/people/1')
      end
      
      should "recognize path with trailing slash" do
        assert_equal({'controller' => 'people', 'action' => 'index'},
          @other_route.recognize('/people/'))
      end
    end
    
    
  end
  
end