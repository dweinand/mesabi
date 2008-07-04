require File.join(File.dirname(__FILE__), '../test_helper')

module Mesabi
  
  class ApplicationTest < Test::Unit::TestCase
    
    context "An Application" do
      setup do
        @app = Application.new
        Application.build_routes {|r| r.match(':controller/:action/:id')}
      end

      should "delegate route map to class" do
        assert_equal Application.route_map, @app.route_map
      end
      
      should "not have a parent module" do
        assert_nil @app.parent_module
      end
    end
    
    
  end
  
end