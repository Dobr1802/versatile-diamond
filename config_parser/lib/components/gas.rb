require 'forwardable'

class Gas < Phase
  extend Forwardable

  def initialize
    super
    @specs = []
    @concentrations = {}
  end

  def_delegator :@specs, :include?

  def spec_class
    GasSpec
  end

  def spec(name)
    @specs << super
  end

  def concentration(specified_spec_str, value, dimension = nil)
    specific_spec = SpecificSpec.new(specified_spec_str)
    syntax_error('.undefined_spec', name: name) unless specific_spec.is_gas? # TODO: strongly connected componente!
    @concentrations[specific_spec] = Dimensions.convert_concentration(value, dimension)
  end
end