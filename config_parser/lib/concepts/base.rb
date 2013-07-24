module VersatileDiamond

  module Concepts

    # The base concept class
    # @abstract
    class Base
      attr_reader :name

      # Each concepts should be have name
      def initialize(name)
        @name = name.to_sym
      end
    end

  end

end