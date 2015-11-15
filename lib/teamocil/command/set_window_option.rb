module Teamocil
  module Command
    class SetWindowOption < ClosedStruct.new(:name, :option, :value)
      def to_s
        "set-window-option -t '#{name}' #{option} #{value}"
      end
    end
  end
end
