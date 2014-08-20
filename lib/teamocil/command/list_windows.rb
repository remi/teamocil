module Teamocil
  module Command
    class ListWindows < ClosedStruct.new(:foo)
      def to_s
        'list-windows'
      end
    end
  end
end
