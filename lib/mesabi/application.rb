module Mesabi
  class Application
    
    attr_accessor :configuration
    
    def initialize(options={})
      self.configuration = OpenStruct.new(options)
    end
    
    def call(env)
      request = Request.new(env)
      params = route_map.recognize(request.path_info, request.request_method)
      if params
        request.params.merge!(params)
        controller = get_controller(params['controller']).new(request)
        controller.run(params['action'])
      else
        [404, {'content_type' => 'text/plain'}, ['Not Found']]
      end
    end
    
    def route_map
      self.class.route_map
    end
    
    def parent_module
      self.class.parent_module
    end
    
    def get_controller(controller)
      parent_module.const_get(controller.capitalize)
    end
    
    class << self
      
      attr_accessor :parent_module, :route_map
      
      def inherited(subclass)
        subclass.parent_module = Object.module_eval("::#{subclass.to_s.gsub(%r((::)?\w+$),'')}")
      end
      
      def build_routes(&block)
        self.route_map = RouteMap.new(&block)
      end
      
    end
    
  end
end