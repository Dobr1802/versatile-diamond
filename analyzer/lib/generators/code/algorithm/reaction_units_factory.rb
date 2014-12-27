module VersatileDiamond
  module Generators
    module Code
      module Algorithm

        # Creates reaction find algorithm units
        class ReactionUnitsFactory < BaseUnitsFactory

          # Initializes reaction find algorithm units factory
          # @param [EngineCode] generator the major code generator
          # @param [TypicalReaction] reaction for which the algorithm is building
          def initialize(generator, reaction)
            super(generator)
            @reaction = reaction

            create_namer! # just create internal names accumulator
            @used_species_pairs = Set.new
          end

          # Makes single specie unit for each nodes list
          # @param [Array] nodes for which the unit will be maked
          # @return [SingleParentNonRootSpecieUnit] the unit of code generation
          def make_unit(nodes)
            if nodes.map(&:dept_spec).uniq.size == 1
              make_single_unit(nodes)
            else
              make_multi_unit(nodes)
            end
          end

          # Gets the reaction creator unit
          # @return [ReactionCreatorUnit] the unit for defines reaction creation code
          #   block
          def creator
            args = [generator.classifier, namer, @reaction, @used_species_pairs.to_a]
            ReactionCreatorUnit.new(*args)
          end

        private

          # Makes unit which contains one specie
          # @param [Array] nodes from which the unit will be created
          # @return [ReactantUnit] which contains one unique specie
          def make_single_unit(nodes)
            dept_spec = nodes.first.dept_spec
            unique_specie = nodes.first.uniq_specie
            @used_species_pairs << [dept_spec, unique_specie]

            args = default_args + [
              dept_spec,
              unique_specie,
              nodes.map(&:atom),
              @reaction.reaction
            ]

            ReactantUnit.new(*args)
          end

          # Makes unit which contains many reactant species
          # @param [Array] nodes from which the unit will be created
          # @return [ReactantUnit] which contains many unique specie
          def make_multi_unit(nodes)
            nodes.each do |node|
              @used_species_pairs << [node.dept_spec, node.uniq_specie]
            end

            atoms_to_specs = Hash[nodes.map { |n| [n.atom, n.dept_spec] }]
            ManyReactantsUnit.new(*default_args, atoms_to_specs, @reaction.reaction)
          end
        end

      end
    end
  end
end
