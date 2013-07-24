module VersatileDiamond

  module Interpreter

    class Where < Component
      include AtomMatcher

      attr_reader :description, :environment

      def initialize(environment, description)
        @environment = environment
        @description = description
        @raw_positions = {}

        @specs = {}
      end

      def position(*atom_strs, **options)
        target, atom = nil
        atom_strs.each do |atom_str|
          atom_sym = atom_str.to_sym
          if @environment.is_target?(atom_sym)
            syntax_error('.cannot_link_targets') if target
            target = atom_sym
          else
            # TODO: maybe very strong validation?
            syntax_error('.should_links_with_target') if atom

            spec_name, atom_keyname = match_used_atom(atom_str)
            spec = (@specs[spec_name] =
              @environment.resolv_alias(spec_name) || Spec[spec_name])

            atom = spec[atom_keyname]
          end
        end
        @raw_positions[target] = [atom, Position[options]]
      end

      def use(*names)
        names.each do |name|
          other = @environment.use_where(name) ||
            syntax_error('.undefined', name: name)

          # TODO: each item duplicated??
          @raw_positions.merge!(Hash[other.raw_positions.map(&:dup)])
          dependent_from << other
        end
      end

      def concretize(target_refs)
        ConcreteWhere.new(self, @raw_positions, target_refs)
      end

      def specs
        @specs.values
      end

      def dependent_from
        @dependent_from ||= Set.new
      end

    protected

      attr_reader :raw_positions

    end

  end

end
