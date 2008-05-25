module Mesabi
  
  class Controller
    
    attr_accessor :request, :response
    
    def initialize(request)
      self.request = request
      self.response = Response.new
    end
    
    def run(action)
      response.body << send(action)
      response.finish
    end
    
  end
  
end