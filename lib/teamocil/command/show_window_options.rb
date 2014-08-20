module Teamocil
  module Command
    class ShowWindowOptions < ClosedStruct.new(:name)
      def to_s
        "show-window-options -gv #{name}"
      end
    end
  end
end
