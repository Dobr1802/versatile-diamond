module VersatileDiamond
  using Patches::RichString

  module Generators
    module Code

      # Provides methods for generated classes which names dependent from
      # external #class_name method
      module PolynameClass

        # Gets the result file name
        # @return [String] the result file name
        # @override
        def file_name
          class_name.underscore
        end

        # Gets define name
        # @return [String] the inclusion warden name
        def define_name
          "#{file_name.upcase}_H"
        end
      end

    end
  end
end
