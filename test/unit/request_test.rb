require File.join(File.dirname(__FILE__), '../test_helper')

module Mesabi
  
  class RequestTest < Test::Unit::TestCase

    context "A request" do

      context "with normal params" do
        setup do
          @env = mock_env("example.com?foo=1;bar=2")
          @request = Request.new(@env)
        end

        should "construct params hash" do
          assert_equal({'foo' => '1', 'bar' => '2'}, @request.params)
        end
      end

      context "with duplicate param keys" do
        setup do
          @env = mock_env("example.com?foo[]=1;foo[]=2;bar=1;bar=2")
          @request = Request.new(@env)
        end

        should "construct params array" do
          assert @request.params['foo'].is_a?(Array), @request.params.inspect
          assert @request.params['foo'].include?('1')
          assert @request.params['foo'].include?('2')
          assert @request.params['bar'].is_a?(Array), @request.params.inspect
          assert @request.params['bar'].include?('1')
          assert @request.params['bar'].include?('2')
        end
      end

      context "with nested params" do
        setup do
          @env = mock_env("example.com?foo[bar]=1;foo[baz]=2")
          @request = Request.new(@env)
        end

        should "construct a nested params hash" do
          assert_equal({'foo' => {'bar' => '1', 'baz' => '2'}}, @request.params)
        end
      end

      context "with faked http method" do
        setup do
          @env = mock_env("example.com/foo?_meth=delete", {:method => 'POST'})
          @request = Request.new(@env)
        end

        should "identify fake http method" do
          assert_equal('DELETE', @request.request_method)
          assert @request.delete?
          assert !@request.post?
        end
      end

    end

  end
  
end