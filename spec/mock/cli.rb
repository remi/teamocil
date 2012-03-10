module Teamocil
  module Mock
    module CLI

      def self.included(base) # {{{
        base.class_eval do

          # Return all messages
          def self.messages # {{{
            @@messages
          end # }}}

          # Change messages
          def self.messages=(messages) # {{{
            @@messages = messages
          end # }}}

          # Do not print anything
          def print_layouts # {{{
            # Nothing
          end # }}}

          # Print an error message and exit the utility
          #
          # @param msg [Mixed] something to print before exiting.
          def bail(msg) # {{{
            Teamocil::CLI.messages << msg
            exit 1
          end # }}}

        end
      end # }}}

    end
  end
end

Teamocil::CLI.send :include, Teamocil::Mock::CLI
