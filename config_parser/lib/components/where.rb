module VersatileDiamond

  class Where < Component
    include AtomMatcher

    def initialize(environment, description)
      @environment = environment
      @description = description
      @raw_positions = {}
    end

    def position(*atom_strs, **options)
      target, atom = nil
      atom_strs.each do |atom_str|
        atom_sym = atom_str.to_sym
        if @environment.is_target?(atom_sym)
          syntax_error('.cannot_link_targets') if target
          target = atom_sym
        else
          syntax_error('.should_links_with_target') if atom # TODO: maybe very strong validation?
          spec_name, atom_keyname = match_used_atom(atom_str)
          atom = (@environment.resolv_alias(spec_name) || Spec[spec_name])[atom_keyname]
        end
      end
      @raw_positions[target] = [atom, Position[options]]
    end

    def use(*names)
      names.each do |name|
        other = @environment.use_where(name) || syntax_error('.undefined', name: name)
        @raw_positions.merge!(Hash[other.raw_positions.map(&:dup)]) # TODO: each item duplicated??
      end
    end

    def concretize(target_refs)
      ConcreteWhere.new(@raw_positions, target_refs, @description)
    end

  protected

    attr_reader :raw_positions

  end

end
