module VersatileDiamond
  module Generators
    module Code

      class Handbook < CppClass

        # Gets name of file which will be generated
        # @return [String] the name of result file without extention
        def file_name
          template_name
        end

        # Checks that lateral reactions presented in original set
        # @return [Boolean] exists or not
        def lateral_exists?
          @generator.spec_reactions.any?(&:lateral?)
        end

        # Check that results contain amorph phase
        # @return [Boolean] contain or not
        def amorph_exists?
          used_lattices.include?(nil)
        end

        # Gets all usable phases of atoms (lattices and amorphous if need)
        # @param [Array] the array of string names of generated dependent entities
        def phases
          used_lattices.map do |lattice|
            lattice.nil? ? 'phase_bondary' : lattice.class.to_s.underscore
          end
        end

        # Gets the atoms quantity
        # @return [Integer] the number of atoms
        def atoms_num
          @generator.classifier.props.size
        end

        # Gets the transitive closured matrix of atom types
        # @return [String] the string rows of matrix
        def atoms_matrix
          matrix = @generator.classifier.general_transitive_matrix.to_a
          matrix_to_s(matrix)
        end

        # Gets the specifications of each atoms
        # @return [String] the result of atom properties specification
        def atoms_specification
          @generator.classifier.specification.join(', ')
        end

        # Deligates the methods to classifier
        # TODO: if not hydrogen used in system then not be generated methods with
        #   hydrogen in source
        %w(actives_to_deactives deactives_to_actives).each do |name|
          define_method(name) { @generator.classifier.public_send(name).join(', ') }
        end

        # Gets the mirror of each termination spec to their numbers on atoms
        # @return [Hash] the hash of numbers of terminations on each atom
        def nums_on_atoms
          @generator.term_specs.each.with_object({}) do |term_spec, hash|
            hash[term_spec.name] = term_nums(term_spec)
          end
        end

      private

        # Gets all used lattices in analysed results
        # @return [Array] the array of lattice instances
        def used_lattices
          @generator.classifier.props.map(&:lattice).uniq
        end

        # Makes string from matrix
        # @param [Array] matrix the original matrix
        # @return [String] matrix as multiline string
        def matrix_to_s(matrix)
          width = @generator.classifier.props_hash.keys.max.to_s.size
          str = matrix.map.with_index do |row, i|
            line = row.join(', ')
            "/* #{i.to_s.rjust(width)} */  #{line}"
          end
          str.join(",\n")
        end

        # Calcs number of terminated species on each atom
        # @param [DependentTermination] term_spec the termination spec for which
        #   numbers will gotten
        # @param [String] the array of numbers as string
        def term_nums(term_spec)
          values = Array.new(props.size) { 0 }
          @generator.classifier.classify(term_spec).each do |i, (_, n)|
            values[i] = n
          end
          values.join(', ')
        end
      end

    end
  end
end