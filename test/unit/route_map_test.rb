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
          }, @route_map.recognize('foo/show/1', 'GET'))
        end
        
        should "not recognize invalid path" do
          assert_nil @route_map.recognize('a/bad_route', 'GET')
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
          }, @route_map.recognize('foo/1', 'GET'))
          assert_equal({
            'controller' => 'foo',
            'action'     => 'new'
          }, @route_map.recognize('foo/new', 'GET'))
        end
        
        should "preserve order in recognizing paths" do
          assert_equal({
            'controller' => 'bar',
            'action'     => 'argh',
            'argh'         => 'foo'
          }, @route_map.recognize('bar/foo', 'GET'))
        end
        
        should "not recognize invalid path" do
          assert_nil @route_map.recognize('a/bad/route', 'GET')
        end
      end
      
      context "with routes with method requirements" do
        setup do
          @route_map = RouteMap.new do |map|
            map.foos("foo", {
              'controller' => 'foo',
              'action'     => 'index',
              'method'     => 'get'
            })
            map.create_foos("foo", {
              'controller' => 'foo',
              'action'     => 'create',
              'method'     => 'post'
            })
          end
        end

        should "recognize correct method" do
          assert_equal({
            'controller' => 'foo',
            'action'     => 'index'
          }, @route_map.recognize('foo', 'GET'))
          assert_equal({
            'controller' => 'foo',
            'action'     => 'create'
          }, @route_map.recognize('foo', 'POST'))
        end
        
      end
      
    end
    
  end
  
end