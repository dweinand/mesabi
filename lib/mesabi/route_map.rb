module Mesabi
  
  class RouteMap
    
    attr_accessor :routes
    
    def initialize
      self.routes = []
      yield self if block_given?
    end
    
    def match(path, options={})
      self.routes << [nil, Route.new(path, options)]
    end
    
    def recognize(path, meth)
      routes.each do |route|
        params = route[1].recognize(path, meth)
        return params if params
      end
      nil
    end
    
    def resources(name)
      create_restful_routes_for(name)
    end
    
    private
    
    def method_missing(name, *args)
      self.routes << [name, Route.new(*args)]
    end
    
    def create_restful_routes_for(name)
      singular_name = name.singular
      self.routes << [name, Route.new(
        "/#{name}", {
          'controller' => name,
          'action'     => 'index',
          'method'     => 'get'
      })]
      self.routes << ["new_#{singular_name}", Route.new(
        "/#{name}/new", {
          'controller' => name,
          'action'     => 'new',
          'method'     => 'get'
      })]
      self.routes << [singular_name, Route.new(
        "/#{name}/:id", {
          'controller' => name,
          'action'     => 'show',
          'method'     => 'get'
      })]
      self.routes << ["edit_#{singular_name}", Route.new(
        "/#{name}/:id/edit", {
          'controller' => name,
          'action'     => 'edit',
           'method'    => 'get'
      })]
      self.routes << ["create_#{singular_name}", Route.new(
        "/#{name}", {
          'controller' => name,
          'action'     => 'create',
          'method'     => 'post'
      })]
      self.routes << ["update_#{singular_name}", Route.new(
        "/#{name}/:id", {
          'controller' => name,
          'action'     => 'update',
          'method'     => 'put'
      })]
      self.routes << ["destroy_#{singular_name}", Route.new(
        "/#{name}/:id", {
          'controller' => name,
          'action'     => 'destroy',
          'method'     => 'delete'
      })]
    end
    
  end
  
end