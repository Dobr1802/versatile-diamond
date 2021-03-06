module VersatileDiamond
  using Patches::RichString

  module Generators
    module Code
      module Algorithm

        # Accumulates the names of variables for generation algorithms in cpp code
        class NameRemember
          # Initializes internal store for all using names
          def initialize
            @names = {}
            @next_names = []
          end

          # Assign unique names for each variables with duplicate error checking
          # @param [String] single_name the singular name of one variable
          # @param [Array | Object] vars the list of remembing variables or single
          #   variable
          def reassign(single_name, vars)
            store_variables(:replace, single_name, vars)
          end

          # Assign unique names for each variables with duplicate error checking
          # @param [String] single_name the singular name of one variable
          # @param [Array | Object] vars the list of remembing variables or single
          #   variable
          # @option [Boolean] :plur_if_need is a flag which if set then passed name
          #   should be pluralized
          def assign(single_name, vars, plur_if_need: true)
            args = [:check_and_store, single_name, vars]
            store_variables(*args, plur_if_need: plur_if_need)
          end

          # Assign next unique name for variable
          # @param [String] single_name without additional index what will using for
          #   make a new next name of variable
          # @param [Object] var the variable for which name will assigned
          def assign_next(single_name, var)
            correct_name = single?(var) ? single_name : single_name.pluralize
            last_name = @next_names.find { |n| n =~ /^#{correct_name}\d+$/ }
            max_index = (last_name && last_name.scan(/\d+$/).first.to_i) || 0
            next_name = "#{correct_name}#{max_index.next}"
            @next_names.unshift(next_name)
            assign(next_name, var, plur_if_need: false)
          end

          # Gets a name of variable
          # @param [Array | Object] vars the variables or single variable for which
          #   name will be gotten
          # @return [String] the name of passed variable or nil
          def name_of(vars)
            if single?(vars)
              names[single_value(vars)]
            else
              check_proc = proc { |var| names[var] }
              if vars.all?(&check_proc)
                name = array_name_for(vars)
                raise 'Not all vars belongs to array' unless name
                name
              elsif vars.any?(&check_proc)
                raise 'Not for all variables in passed set the name is presented'
              else
                nil
              end
            end
          end

          # Removes records about passed variables
          # @param [Array | Object] vars the variables or single variable which will be
          #   removed from internal cache
          def erase(vars)
            as_arr(vars).each { |var| names.delete(var) }
          end

          # Checks that passed vars have same array variable name
          # @param [Array] vars the list of variables which will be checked
          # @return [Boolean] are vars have same array variable name or not
          def array?(vars)
            !!array_name_for(vars)
          end

        private

          attr_reader :names

          # Gets a hash where keys are names and values are variables
          # @return [Hash] the inverted names hash
          def variables
            names.invert
          end

          # Wraps passed variable to array if it not an array
          # @param [Array | Object] vars the cheking and may be wrapping variable
          # @return [Array] the original array or wrapped to array variable
          def as_arr(vars)
            vars.is_a?(Array) ? vars : [vars]
          end

          # Checks that passed variable is single
          # @param [Array | Object] vars the checkable variable
          # @return [Boolean] is single or not
          def single?(vars)
            !vars.is_a?(Array) || vars.size == 1
          end

          # Gets the value of single variable
          # @param [Array | Object] vars the single variable for which value will be
          #   gotten
          # @return [Object] the value of single variable
          def single_value(vars)
            vars.is_a?(Array) ? vars.first : vars
          end

          # Gets an array name for variables
          # @param [Array] vars the variables for which array name will be gotten
          # @return [String] the name of array that respond to passed variables
          def array_name_for(vars)
            stored_names = vars.map { |var| names[var] }
            array_name = stored_names.first.scan(/^\w+/).first

            if stored_names.any? { |name| !name.match(/^#{array_name}\[\d+\]$/) }
              nil
            else
              array_name
            end
          end

          # Assign unique names for each variables
          # @param [Symbol] method_name the method of name which will used for assign
          #   name for each variable
          # @param [String] single_name the singular name of one variable
          # @param [Array | Object] vars the list of remembing variables or single
          #   variable
          # @option [Boolean] :plur_if_need see at #assign same option
          def store_variables(method_name, single_name, vars, plur_if_need: true)
            if single?(vars)
              send(method_name, single_name, single_value(vars))
            else
              plur_name = plur_if_need ? single_name.pluralize : single_name
              vars.each_with_index do |var, i|
                send(method_name, "#{plur_name}[#{i}]", var)
              end
            end
          end

          # Stores a variable with some name with duplicate error checking
          # @param [String] name the name of storing variable
          # @param [Object] var the storing variable
          def check_and_store(name, var)
            raise %(Variable "#{name}" already has name "#{names[var]}") if names[var]
            raise %(Name "#{name}" already used) if variables[name]
            names[var] = name
          end

          # Replases a variable with some name without error checking
          # @param [String] name the name of storing variable
          # @param [Object] var the storing variable
          def replace(name, var)
            replasing_var = variables[name]
            names.delete(replasing_var)
            names[var] = name
          end
        end

      end
    end
  end
end
