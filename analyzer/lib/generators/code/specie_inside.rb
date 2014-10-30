module VersatileDiamond
  module Generators
    module Code

      # Provides method that characterize the inside of specie
      module SpecieInside
        include SpeciesUser

        # Gets number of sceleton atoms used in specie and different from atoms of
        # parent specie
        #
        # @return [Integer] the number of atoms
        def atoms_num
          spec.target.links.size
        end

        # Delegates classification to atom classifier from engine code generator
        # @param [Concepts::Atom | Concepts::AtomRefernce | Concepts::SpecificAtom]
        #   atom which will be classificated
        # @return [Integer] an index of classificated atom
        def role(atom)
          generator.classifier.index(spec, atom)
        end

      protected

        # Delegates indexation of atom to atom sequence instance
        # @param [Concepts::Atom | Concepts::AtomRefernce | Concepts::SpecificAtom]
        #   atom which will be indexed
        # @return [Integer] an index of atom
        def index(atom)
          sequence.atom_index(atom)
        end

      private

        # Delegates getting delta to atom sequence instance
        # @return [Integer] the delta of addition atoms in atom sequence
        def delta
          sequence.delta
        end
      end

    end
  end
end
