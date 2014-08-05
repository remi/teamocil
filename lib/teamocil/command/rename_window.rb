module Teamocil
  module Command
    class RenameWindow < ClosedStruct.new(:name)
      def to_s
        "rename-window '#{name}'"
      end
    end
  end
end
