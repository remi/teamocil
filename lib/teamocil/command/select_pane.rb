module Teamocil
  module Command
    class SelectPane < ClosedStruct.new(:index)
      def to_s
        "select-pane -t #{index}"
      end
    end
  end
end
