module VersatileDiamond
  module Interpreter

    # Interprets equation properties and pass it to concept instance.
    module EquationProperties
      include Modules::BoundaryTemperature

      # Interpret enthalpy line
      # @param [Float] value the value of enthalpy
      # @param [String] dimension the dimension of enthalpy
      def enthalpy(value, dimension = nil)
        converted_value = Tools::Dimension.convert_energy(value, dimension)
        forward.enthalpy = converted_value
        reverse.enthalpy = -converted_value
      end

      # Interpret activation line and setup forward and reverse activation
      # energy for concept
      #
      # @param [Float] value the value of activation energy
      # @param [String] dimension the dimension of activation energy
      def activation(value, dimension = nil)
        converted_value = Tools::Dimension.convert_energy(value, dimension)
        forward.activation = converted_value
        reverse.activation = converted_value
      end

      %w(forward reverse).each do |dir|
        # Interpret #{dir} activation energy line
        # @param [Float] value the value of activation energy
        # @param [String] dimension the dimension of activation energy
        define_method("#{dir}_activation") do |value, dimension = nil|
          send(dir).activation =
            Tools::Dimension.convert_energy(value, dimension)
        end

        # Interpret #{dir} rate line
        # @param [Float] value the value of pre-exponencial factor
        # @param [String] dimension the dimension of rate
        define_method("#{dir}_rate") do |value, dimension = nil|
          gases_num = send(dir).gases_num
          send(dir).rate = Tools::Dimension.convert_rate(
            eval_value_if_string(value, gases_num), gases_num, dimension)
        end
      end

    private

      # Represents reaction concept for forward reaction direction
      # @return [Concepts::UbiquitousReaction] current concept
      def forward
        @concept
      end

      # Makes reaction concept for reverse reaction direction, cache it and
      # store it to Chest
      #
      # @return [Concepts::UbiquitousReaction] reverse of current concept
      def reverse
        return @reverse if @reverse
        @reverse = forward.reverse
        Tools::Chest.store(@reverse)
        @reverse
      end

      # Evaluate value if it passed as formula
      # @param [Float] value the evaluating value
      # @param [Integer] gases_num number of gases in evaluating case
      def eval_value_if_string(value, gases_num)
        if value.is_a?(String)
          t_str = "T = #{current_temperature(gases_num)}"
          eval("#{t_str}; #{value}")
        else
          value
        end
      end
    end

  end
end
