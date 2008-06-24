require File.join(File.dirname(__FILE__), '../test_helper')

module Mesabi
  
  class ControllerTest < Test::Unit::TestCase
    
    context "A controller" do
      
      setup do
        @env = mock_env("http://www.example.com?foo=1;bar=2")
        @request = Request.new(@env)
        @controller = Controller.new(@request)
      end

      should "delegate params to request" do
        assert_equal @request.params, @controller.params
      end
      
      context "on redirect" do
        
        setup do
          @url = "http://foo.example.com/"
          @result = @controller.redirect_to(@url)
        end

        should "return redirected html" do
          assert_match /redirected/, @result
          assert_match @url, @result
        end
        
        should "set response location header" do
          assert_equal @url, @controller.response[:location]
        end
        
        should "set response status" do
          assert_equal 302, @controller.response.status
        end
        
      end
      
    end
    
  end
  
end