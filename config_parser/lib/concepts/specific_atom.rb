module VersatileDiamond
  module Concepts

    # Specified atom class, contain additional atom states like incoherentness,
    # unfixness and activeness
    class SpecificAtom

      # Error for case if state for atome already exsit
      class AlreadyStated < Exception; end

      extend Forwardable
      def_delegators :@atom, :lattice, :lattice=

      # @param [Atom] atom the specified atom
      def initialize(atom)
        @atom = atom.dup # because atom can be changed by mapping algorithm
        @options = []
      end

      # Compares current instance with other
      # @param [Atom | AtomReference | SpecificAtom] other the other atom with
      #   which comparing do
      # @return [Boolean] is the same atom or not
      def same?(other)
        if self.class == other.class
          @atom.same?(other.atom) && @options.sort == other.options.sort
        else
          false
        end
      end

      # Activates atom instance
      def active!
        @options << :active
      end

      %w(incoherent unfixed).each do |state|
        sym_state = state.to_sym
        # Defines methods for changing atom state
        # @raise [AlreadyStated] if atom already has setuping state
        define_method("#{state}!") do
          raise AlreadyStated if send("#{sym_state}?")
          @options << sym_state
        end

        define_method("#{state}?") do
          @options.include?(sym_state)
        end
      end

      # Counts active bonds
      # @return [Integer] the number of active bonds
      def actives
        @options.select { |o| o == :active }.size
      end

      # def diff(other)
      #   if self.class == other.class
      #     other.relevants - relevants
      #   else
      #     relevants
      #   end
      # end

      def to_s
        chars = @options.map do |value|
          case value
          when :active then '*'
          when :incoherent then 'i'
          when :unfixed then 'u'
          end
        end
        "#{@atom}[#{chars.sort.join(', ')}]"
      end

    protected

      attr_reader :atom, :options

      # def relevants
      #   @options - [:active]
      # end
    end

  end
end
