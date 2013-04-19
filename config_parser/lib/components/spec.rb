# The class instance contains atoms and bonds between them.
# When one spec uses an other then atoms and bonds from another spec coping to original spec.
# If spec is recursive (i.e. uses itself) then no copy, reference to used atom creates instead.
class Spec < Component
  class << self
    include SyntaxChecker

    def [](spec_name)
      @@common_specs[spec_name] || syntax_error('spec.undefined', name: spec_name)
    end

    def add(spec_name)
      @@common_specs ||= {}
      syntax_error('spec.already_defined', name: spec_name) if @@common_specs[spec_name]
      @@common_specs[spec_name] = new(spec_name)
    end
  end

  def initialize(name)
    @name = name

    @atoms, @links = {}, {}
    @aliases = {}

    @internal_bonds = 0
  end

  def external_bonds
    valences = @atoms.values.map(&:valence)
    valences.size == 1 && valences.first == 1 ? 0 : valences.inject(:+) - 2 * @internal_bonds
  end

  def external_bonds_for(atom_keyname)
    atom = @atoms[atom_keyname]
    atom.valence + @links[atom].select { |link, _| link.is_a?(Bond) }.size
  end

  def [](atom_keyname)
    @atoms[atom_keyname] || syntax_error('spec.undefined_atom_keyname', keyname: atom_keyname)
  end

  def aliases(**refs)
    refs.each do |keyname, spec_name|
      spec = Spec[spec_name.to_sym]
      duplicated_atoms = spec.duplicate_atoms
      adsorb_links(spec.links, duplicated_atoms)
      @aliases[keyname] = spec.alias_atoms(duplicated_atoms)
    end
  end

  def atoms(**refs)
    refs.each do |keyname, atom|
      real_atom = detect_atom(atom)
      @atoms[keyname] = real_atom
      @links[real_atom] ||= []
    end
  end

  def bond(first, second, **options)
    link(Bond, first, second, options)
    @internal_bonds += 1
  end

  def dbond(first, second)
    2.times { bond(first, second) }
  end

protected

  attr_reader :name, :links

  def duplicate_atoms
    atoms = @atoms.values
    Hash[atoms.zip(atoms.map(&:dup))] # TODO: dup ?
  end

  def alias_atoms(duplicated_atoms)
    Hash[@atoms.map { |key, atom| [key, duplicated_atoms[atom]] }]
  end

private

  def detect_atom(atom_str)
    simple_atom(atom_str) || defined_atom(atom_str)
  end

  def simple_atom(atom_str)
    if (atom_name = Matcher.atom(atom_str))
      Atom[atom_name]
    end
  end

  def defined_atom(atom_str)
    if (match = Matcher.used_atom(atom_str))
      spec_name, atom_keyname = match.map(&:to_sym)
      if spec_name == @name
        self.[](atom_keyname) # checks existing atom keyname
        AtomReference.new(self, atom_keyname)
      elsif (aliased_spec = @aliases[spec_name])
        aliased_spec[atom_keyname]
      else
        spec = Spec[spec_name]
        duplicated_atoms = spec.duplicate_atoms
        adsorb_links(spec.links, duplicated_atoms)
        duplicated_atoms[spec[atom_keyname]]
      end
    end
  end

  def adsorb_links(readsorbed_links, duplicated_atoms)
    readsorbed_links.each do |atom, links|
      curr_links = @links[duplicated_atoms[atom]] = []
      links.each do |another_atom, bond_instance|
        curr_links << [duplicated_atoms[another_atom], bond_instance]
      end
    end
  end

  def link(instance, first, second, **options)
    first, second = existing_atoms(first, second)
    yield(first, second) if block_given?
    @links[first] = [second, instance]
    @links[second] = [first, instance]
  end

  def existing_atoms(*atom_keynames)
    atom_keynames.map { |atom_keyname| self.[](atom_keyname) }
  end
end
