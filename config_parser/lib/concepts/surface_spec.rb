module VersatileDiamond
  module Concepts

    # Represents surface structure
    class SurfaceSpec < Spec
      include SurfaceLinker

      # Returns that spec is not gas
      # @return [Boolean] gas or not
      def is_gas?
        false
      end

      # Finds position relation between two atoms, where first atom is atom of
      # largest structure (specie) and relation has direction from atom of
      # first spec to atom of second spec
      #
      # @param [Atom] first the first atom
      # @param [Atom] second the second atom
      # @return [Position] the position relation or nil
      def position_between(first, second)
        relation = relation_between(first, second)
        relation && relation.face &&
          Position[face: relation.face, dir: relation.dir]
      end

    protected

      # After linking finds position by relation rules from crystal lattice
      # @param [Array] args the argumens of super method
      # @raise [Position::UnspecifiedAtoms] unless at least one atom
      #   belonging to lattice
      # @override
      def link_together(*atoms, instance)
        raise Position::UnspecifiedAtoms unless at_least_one_latticed?(atoms)

        super(*sort(atoms), instance)
        find_positions
      end

    private

      # Gets opposite relation between first and second atoms for passed
      # relation instance
      #
      # @param [Atom] first the first of two linking atoms
      # @param [Atom] second the second of two linking atoms
      # @param [Bond] relation the instance of relation
      # @raise [Lattices::Base::UndefinedRelation] when passed relation is
      #   undefined
      # @return [Bond] the opposite relation
      def opposit_relation(first, second, relation)
        first.lattice.opposite_relation(second.lattice, relation)
      end

      # Finds and store positions between transitive bonded atoms
      def find_positions
        atom_instances.combination(2).each do |atoms|
          next if !at_least_one_latticed?(atoms) || relation_between(*atoms)
          first, second = sort(atoms)

          positions =
            first.lattice.positions_between(first, second, links)
          next unless positions

          link_with_other(first, second, *positions)
        end
      end

      # Checks that at least one atoms belongs to lattice
      # @param [Array] atoms the array of atoms
      # @return [Boolean] has latticed atom or not
      def at_least_one_latticed?(atoms)
        atoms.any?(&method(:has_lattice?))
      end

      # Sorts atoms by having crystall lattice
      # @param [Array] atoms the array of atoms
      # @return [Array] the sorted atoms array
      def sort(atoms)
        index = atoms.index(&method(:has_lattice?))
        first = atoms.delete_at(index)
        [first, atoms.pop]
      end

      # Checks that atoms is related
      # @param [Atom] first the first atom
      # @param [Atom] second the second atom
      # @return [Boolean] related or not
      # TODO: move to super?
      def relation_between(first, second)
        links[first] &&
          (atom_with_rel = links[first].find { |atom, _| atom == second }) &&
          ((_, rel) = atom_with_rel) && rel
      end
    end

  end
end