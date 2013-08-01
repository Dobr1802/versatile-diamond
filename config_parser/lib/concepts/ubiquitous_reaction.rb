module VersatileDiamond
  module Concepts

    # Instance of it class contain source and product specs. Also contained
    # all kinetic properties: enthalpy, activation energy and pre-exponential
    # factor as "raw" rate variable. Setuping it values provides trough
    # corresponding instance assertion methods.
    # TODO: rspec
    class UbiquitousReaction < Named
      # include Modules::BoundaryTemperature
      # include Modules::ListsComparer

      # Exception class for cases when property already setted
      class AlreadySet < Exception
        attr_reader :property
        def initialize(property); @property = property end
      end

      class << self
      private
        # Defines some property setter by adding assertion methods for forward
        # and reverse directions
        def define_property_setter(property)
          # Defines forward direction property setter
          # @param [Float] value the value of property
          # @param [Symbol] prefix the prefix of direction which need for
          #   futher processing
          define_method("forward_#{property}=") do |value, prefix = :forward|
            if instance_variable_get("@#{property}".to_sym)
              raise UbiquitousReaction::AlreadySet.new("#{prefix}_#{property}")
            end

            update_attribute(property, value, prefix)
          end

          define_method("reverse_#{property}=") do |value|
            reverse.send("forward_#{property}=", value, :reverse)
          end
        end
      end

      attr_reader :source, :products #, :parent

      # Store source and product specs
      # @param [Array] source the array of source specs
      # @param [Array] products the array of product specs
      def initialize(name, source, products)
        super(name)
        @source, @products = source, products
      end


      # %w(source products).each do |specs|
      #   define_method("#{specs}_gases_num") do
      #     instance_variable_get("@#{specs}".to_sym).map(&:is_gas?).
      #       select { |v| v }.size
      #   end
      # end

      def enthalpy=(value)
        self.forward_enthalpy = value
        self.reverse_enthalpy = -value
      end

      define_property_setter :activation
      define_property_setter :rate

  #     def to_s
  #       specs_to_s = -> specs { specs.map(&:to_s).join(' + ') }
  #       "#{specs_to_s[@source]} = #{specs_to_s[@products]}"
  #     end

  #     def visit(visitor)
  #       analyze_and_source_specs(visitor)

  #       if rate > 0
  #         accept_self(visitor)
  #       else
  #         visitor.accept_abstract_equation(self)
  #       end

  # # p @name
  # # puts "@@ rate: %1.3e" % rate
  # # return unless @atoms_map
  # # @atoms_map.each do |(source, product), indexes|
  # #   print "  #{source} => #{product} :: "
  # #   puts indexes.map { |one, two| "#{one} -> #{two}" }.join(', ')
  # # end
  #     end

  #     def same?(other)
  #       spec_compare = -> spec1, spec2 { spec1.same?(spec2) }
  #       lists_are_identical?(@source, other.source, &spec_compare) &&
  #         lists_are_identical?(@products, other.products, &spec_compare)
  #     end

  #     def dependent_from
  #       @dependent_from ||= []
  #     end

  #     def organize_dependencies(not_ubiquitous_equations)
  #       termination_specs = @source.select { |spec| spec.is_a?(TerminationSpec) }
  #       simple_specs = @source - termination_specs

  #       not_ubiquitous_equations.each do |possible_parent|
  #         simples_are_identical =
  #           lists_are_identical?(simple_specs, possible_parent.simple_source) do |spec1, spec2|
  #             spec1.same?(spec2)
  #           end
  #         next unless simples_are_identical

  #         terminations_are_covering =
  #           lists_are_identical?(termination_specs, possible_parent.complex_source) do |termination, complex|
  #             termination.cover?(complex)
  #           end
  #         next unless terminations_are_covering

  #         dependent_from << possible_parent
  #       end
  #     end

  #     def check_and_clear_parent_if_need
  #       return unless @parent
  #       # calling current .same? method for each child class
  #       unless same?(@parent)
  #       # unless UbiquitousEquation.instance_method(:same?).bind(self).call(@parent)
  #         @parent = nil
  #       end
  #     end

  #     def rate
  #       return 0 unless @rate
  #       @activation ||= 0

  #       r = @rate * Math.exp(-(@activation * 1000) /
  #         (Dimensions::R * current_temperature(source_gases_num)))
  #       @source.reduce(r) do |acc, spec|
  #         spec.is_gas? ? acc * Gas.instance[spec] : acc
  #       end
  #     end

    protected

      # attr_writer :parent

      # def reverse
      #   return @reverse if @reverse

      #   @reverse = Equation.register(self.class.new(*reverse_params))
      #   @name << ' forward'
      #   yield(@reverse) if block_given?
      #   @reverse.parent = parent.reverse if parent
      #   @reverse
      # end

    private

      define_property_setter :enthalpy

    #   def reverse_params
    #     ["#{@name} reverse", @products, @source]
    #   end

      def update_attribute(attribute, value, _prefix = nil)
        instance_variable_set("@#{attribute}".to_sym, value)
      end

    #   def accept_self(visitor)
    #     visitor.accept_ubiquitous_equation(self)
    #   end

    #   def analyze_and_source_specs(visitor)
    #     @source.each { |spec| spec.visit(visitor) }
    #   end
    end

  end
end
