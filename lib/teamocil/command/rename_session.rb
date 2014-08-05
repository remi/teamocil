module Teamocil
  module Command
    class RenameSession < ClosedStruct.new(:name)
      def to_s
        "rename-session '#{name}'"
      end
    end
  end
end
