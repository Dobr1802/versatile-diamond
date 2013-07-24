module VersatileDiamond

  module Concepts

    class ActiveBond < TerminationSpec
      include Singleton

      def name
        '*'
      end

      def external_bonds
        0
      end

      def to_s
        name
      end

      def cover?(specific_spec)
        specific_spec.active?
      end
    end

  end

end
