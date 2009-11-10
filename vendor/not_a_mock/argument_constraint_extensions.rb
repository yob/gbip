require 'set'

module Spec #:nodoc:
  module Mocks #:nodoc:
    class AnyOrderArgConstraint #:nodoc:
      def initialize(array)
        @array = array
      end
      
      def ==(arg)
        Set.new(@array) == Set.new(arg)
      end
        
      def inspect
        "in_any_order(#{@array.inspect})"
      end
    end
    
    module ArgumentMatchers #:nodoc:
      class AnyArgMatcher #:nodoc:
        def inspect
          'anything'
        end
      end

      def in_any_order(array)
        Spec::Mocks::AnyOrderArgConstraint.new(array)
      end
    end

  end
end
