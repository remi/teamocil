module Teamocil
  module Command
    class ShowOptions < ClosedStruct.new(:name)
      def to_s
        "show-options -gv #{name}"
      end
    end
  end
end
