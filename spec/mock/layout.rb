module Teamocil
  module Mock
    module Layout
      def self.included(base)
        base.class_eval do
          # Do not execute anything
          def execute_commands(commands)
            # Nothing
          end
        end
      end
    end
  end
end

Teamocil::Layout.send :include, Teamocil::Mock::Layout
