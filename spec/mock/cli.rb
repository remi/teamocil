module Teamocil
  module Mock
    module CLI

      def self.included(base) # {{{
        base.class_eval do

          # Do not print anything
          def print_layouts
            # Nothing
          end

        end
      end # }}}

    end
  end
end

Teamocil::CLI.send :include, Teamocil::Mock::CLI
