module VersatileDiamond
  module Generators
    module Code

      # Creates Original Specie class which is used when specie is simmetric
      class OriginalSpecie < BaseSpecie
        extend SubSpecie

        use_prefix 'original'

        # Initialize original specie class code generator
        # @param [EngineCode] generator see at #super same argument
        # @param [Specie] specie which is main specie class generator
        def initialize(generator, specie)
          super(generator)
          @specie = specie
          @_prefix = nil
        end

        # Doesn't be automaticaly delegated because current instance already
        # have #template_name method
        undef :template_name

        # Gets the main specie to which all undefined methods are redirects
        # @return [Specie] the main original specie
        def target_specie
          @specie
        end

        # Delegates all missed methods to target specie for correct rendering source
        # code template
        #
        # @param [Array] args the arguments of missed method
        def method_missing(*args, &block)
          # friend call of specie methods
          target_specie.send(*args, &block)
        end

      private

        # Original specie class haven't find algorithms by default
        # @return [Boolean] false
        def render_find_algorithms?
          false
        end

        # Gets the name of directory where will be stored result file
        # @return [String] the name of result directory
        # @override
        def outer_dir_name
          'originals'
        end

        # Substitute base class name for original specie template rendering
        # @return [String] the name of base class
        def base_class_name
          target_specie.wrapped_base_class_name
        end

        # Gets a list of parent species
        # @return [Array] the array of parent specie code generators
        def head_used_objects
          target_specie.header_parents_dependencies
        end

        # Original specie doesn't have dependencies from species in source file
        # @return [Array] the empty array
        def body_include_objects
          []
        end
      end

    end
  end
end
