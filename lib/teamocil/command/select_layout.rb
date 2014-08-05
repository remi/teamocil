module Teamocil
  module Command
    class SelectLayout < ClosedStruct.new(:layout)
      def to_s
        "select-layout '#{layout}'"
      end
    end
  end
end
