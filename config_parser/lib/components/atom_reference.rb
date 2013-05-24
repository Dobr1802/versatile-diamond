class AtomReference
  attr_reader :spec, :atom

  def initialize(spec, atom_keyname)
    @spec, @atom_keyname = spec, atom_keyname
    @atom = @spec[@atom_keyname]
  end

  def valence
    @spec.external_bonds_for(@atom_keyname)
  end

  def specified?
    @atom.specified?
  end

  def to_s
    "&#{@atom}"
  end

  # TODO: maybe better to use def_delegator
  def ==(other)
    @atom == other
  end
end
