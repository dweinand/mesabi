module Mesabi
  
  class Controller
    
    attr_accessor :request, :response
    
    def initialize(request)
      self.request = request
      self.response = Response.new
    end
    
    def run(action)
      response.write send(action)
      response.finish
    end
    
    def redirect_to(url)
      response.status = 302
      response[:location] = url
      "<html><body>You are being <a href=\"#{url}\">redirected</a>.</body></html>"
    end
    
    def params
      request.params
    end
    
  end
  
end