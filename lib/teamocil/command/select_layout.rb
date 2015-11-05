module Teamocil
  module Command
    class SelectLayout < ClosedStruct.new(:layout, :name)
      def to_s
        "select-layout -t '#{name}' '#{layout}'"
      end
    end
  end
end
