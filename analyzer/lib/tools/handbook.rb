module VersatileDiamond
  module Tools

    # Provides useful methods for RSpec
    module Handbook
      # Hook for including case
      # @param [Module] base the module which uses current module
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        # Resets internal cache for RSpec
        def reset
          @@__handbook.clear
        end

      private

        # Provides a special action for defining memoised instance methods
        # @param [Symbol] name the name of defining method
        # @yield the body of method
        def set(name, &block)
          hb = (@@__handbook ||= {})
          define_method(name) do
            @__evaluator ||= self.class.new
            hb[name] ||= @__evaluator.instance_eval(&block)
          end
        end
      end
    end

  end
end
