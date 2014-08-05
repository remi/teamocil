module Teamocil
  module Command
    class SendKeys < ClosedStruct.new(:keys)
      def to_s
        "send-keys '#{keys}'"
      end
    end
  end
end
