module Mesabi
  
  class Request < Rack::Request
    PARAMS_REGEXP = %r([\[\]]*([^\[\]]+)\]*)
    
    attr_accessor :route_params
    
    def params
      @params ||= normalize_params(super)
    end
    
    private
    
    def normalize_params(rack_params={})
      rack_params.inject({}) {|h,p| normalize_param(p[0], p[1], h)}
    end
    
    def normalize_param(name, val=nil, hash={})
      key, after = split_param_name(name)
      
      if after.empty? || after == '[]'
        hash[key] = val
      else
        hash[key] ||= {}
        hash[key].merge!(normalize_param(after, val, hash[key]))
      end
      hash
    end
    
    def split_param_name(name)
      match = PARAMS_REGEXP.match(name)
      [match[1] || '', match.post_match || '']
    end
    
  end
  
end