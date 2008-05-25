require 'benchmark'

TIMES = (ARGV[0] || 100_000).to_i

module Foo
  
  class Bar
    
    def report_raw(klass)
      klass.new.report
    end
    
    def report_get_with_parent(klass)
      self.class.parent_module.const_get(klass).new.report
    end
    
    def report_get(klass)
      Chunky.const_get(klass).new.report
    end
    
    class << self
      
      attr_accessor :parent_module
      
      def inherited(subclass)
        subclass.parent_module = Object.module_eval("::#{subclass.to_s.gsub(%r((::)?\w+$),'')}")
      end
      
    end
    
  end
  
end

module Chunky
  
  class Bacon < Foo::Bar
    
  end
  
  class Bits
    
    def report
      "bacon!"
    end
    
  end
  
end

Benchmark.bm do |x|
  x.report("direct") { TIMES.times { Chunky::Bits.new.report } }
  x.report("raw") { TIMES.times { Chunky::Bacon.new.report_raw(Chunky::Bits) } }
  x.report("const_get") do
    TIMES.times { Chunky::Bacon.new.report_get("Bits") }
  end
  x.report("const_get w/ parent") do
    TIMES.times { Chunky::Bacon.new.report_get_with_parent("Bits") }
  end
end
