module Mesabi
  
  class Route
    SEPERATORS_REGEXP = /([^\/;.,?]+)/
    SEGMENT_REGEXP    = /(:([a-z_][a-z0-9_]*|:))/
    
    attr_accessor :original_path, :segments, :regexp, :options
    
    def initialize(path, options={})
      self.original_path = path
      self.segments      = []
      self.options       = options
      self.regexp        = regexp_for(path)
    end
    
    def recognize(path)
      return unless (match = regexp.match(path))
      params = options.dup
      match.captures.each_with_index do |capture, i|
        params[segments[i]] = capture
      end
      params
    end
    
    private
    
    def regexp_for(path)
      regexp_path = Regexp.escape(path.gsub(/\/$/,'')).gsub(SEGMENT_REGEXP) do |segment|
        self.segments << segment.gsub(/\:/,'')
        SEPERATORS_REGEXP.source
      end
      Regexp.compile("^#{regexp_path}/?$")
    end
    
  end
  
end