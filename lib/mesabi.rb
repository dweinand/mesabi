require 'rubygems'
require 'rack'
require 'ostruct'

$LOAD_PATH.unshift File.dirname(__FILE__) unless
  $LOAD_PATH.include?(File.dirname(__FILE__)) ||
  $LOAD_PATH.include?(File.expand_path(File.dirname(__FILE__)))

require 'mesabi/request'
require 'mesabi/response'
require 'mesabi/route'
require 'mesabi/route_map'
require 'mesabi/controller'

module Mesabi #:nodoc:
  
  class Application
    
    attr_accessor :configuration, :route_map
    
    def initialize(options={})
      self.configuration = OpenStruct.new(options)
    end
    
    def call(env)
      request = Request.new(env)
      if (params = route_map.recognize(request.path_info, request.request_method))
       request.params.merge!(params)
       controller = get_controller(params['controller']).new(request)
       controller.run(params['action'])
      else
        [404, {'content_type' => 'text/plain'}, ['Not Found']]
      end
    # rescue
    #   [200, {'content_type' => 'text/plain'}, [params.inspect]]
    end
    
    def build_routes(&block)
      self.route_map = RouteMap.new(&block)
    end
    
    def parent_module
      self.class.parent_module
    end
    
    def get_controller(controller)
      parent_module.const_get(controller.capitalize)
    end
    
    class << self
      
      attr_accessor :parent_module
      
      def inherited(subclass)
        subclass.parent_module = Object.module_eval("::#{subclass.to_s.gsub(%r((::)?\w+$),'')}")
      end
      
    end
    
  end
  
end