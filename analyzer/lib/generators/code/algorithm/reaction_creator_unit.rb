module VersatileDiamond
  module Generators
    module Code
      module Algorithm

        # The instance of class could defines all neccessary variables and calls
        # engine framework method for create a reaction which was found
        class ReactionCreatorUnit
          include CommonCppExpressions
          include AtomCppExpressions

          # Initializes the creator
          # @param [NameRemember] namer the remember of using names of variables
          # @param [TypicalReaction] reaction which uses in current building algorithm
          # @param [Array] species the list of all previously defined unique species
          def initialize(namer, reaction, species)
            @namer = namer
            @reaction = reaction
            @species = species.sort
          end

          # Gets the code lines for reaction creation
          # @return [String] the lines by which the reaction will be created
          def lines
            if @species.size == 1
              create_line
            else
              define_target_species_variable_line + create_line
            end
          end

        private

          attr_reader :namer

          # Gets the cpp code string with creation of target reaction
          # @return [String] the cpp code line with creation target reaction call
          def create_line
            code_line("create<#{@reaction.class_name}>(#{namer.name_of(@species)});")
          end

          # Finds previously defined atom
          # @param [UniqueSpecie] specie see at #spec_by_role_call same argument
          # @return [Concepts::Atom | Concepts::AtomRelation | Concepts::SpecificAtom]
          #   atom which already defined before
          def atom_of(specie)
            specie.proxy_spec.anchors.find { |a| namer.name_of(a) }
          end

          # Makes code which gets target specie instance from passed atom
          # @param [UniqueSpecie] specie which simulation instance will be gotten
          # @return [String] the string of cpp code with specByRole call
          def spec_by_role_call(specie)
            atom = atom_of(specie)
            super(atom, specie, atom)
          end

          # Gets the line with definition of target species array variable
          # @return [String] th ecpp code line with definition of target species var
          def define_target_species_variable_line
            items = @species.map { |s| namer.name_of(s) || spec_by_role_call(s) }
            namer.reassign('target', @species)
            define_var_line('SpecificSpec *', @species, items)
          end
        end

      end
    end
  end
end
