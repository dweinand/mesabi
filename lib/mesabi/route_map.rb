module Mesabi
  
  class RouteMap
    
    attr_accessor :routes
    
    def initialize
      self.routes = []
      yield self if block_given?
    end
    
    def match(path, options={})
      self.routes << Route.new(path, options)
    end
    
    def recognize(path)
      routes.each do |route|
        params = route.is_a?(Array) ?
          route[1].recognize(path) : 
          route.recognize(path)
        return params if params
      end
      nil
    end
    
    def method_missing(name, *args)
      self.routes << [name, Route.new(*args)]
    end
    
  end
  
end