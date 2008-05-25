require File.join(File.dirname(__FILE__), '../test_helper')

module Mesabi
  
  class RouteMapTest < Test::Unit::TestCase
    
    context "A route map" do
      
      context "with generic routes" do
        setup do
          @route_map = RouteMap.new do |map|
            map.match(":controller/:action/:id")
          end
        end

        should "recognize correct path" do
          assert_equal({
            'controller' => 'foo',
            'action'     => 'show',
            'id'         => '1'
          }, @route_map.recognize('foo/show/1'))
        end
        
        should "not recognize invalid path" do
          assert_nil @route_map.recognize('a/bad_route')
        end
      end
      
      context "with named routes" do
        setup do
          @route_map = RouteMap.new do |map|
            map.new_foo("foo/new", {'controller' => 'foo', 'action' => 'new'})
            map.foo("foo/:id", {'controller' => 'foo', 'action' => 'show'})
            map.bar("bar/:argh", {'controller' => 'bar', 'action' => 'argh'})
            map.foo_bar("bar/foo", {'controller' => 'bar', 'action' => 'foo'})
          end
        end

        should "recognize correct path" do
          assert_equal({
            'controller' => 'foo',
            'action'     => 'show',
            'id'         => '1'
          }, @route_map.recognize('foo/1'))
          assert_equal({
            'controller' => 'foo',
            'action'     => 'new'
          }, @route_map.recognize('foo/new'))
        end
        
        should "preserve order in recognizing paths" do
          assert_equal({
            'controller' => 'bar',
            'action'     => 'argh',
            'argh'         => 'foo'
          }, @route_map.recognize('bar/foo'))
        end
        
        should "not recognize invalid path" do
          assert_nil @route_map.recognize('a/bad/route')
        end
      end
      
    end
    
    
  end
  
end