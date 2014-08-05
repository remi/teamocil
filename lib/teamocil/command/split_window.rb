module Teamocil
  module Command
    class SplitWindow < ClosedStruct.new(:root)
      def to_s
        "split-window #{options.join(' ')}"
      end

      def options
        [].tap do |options|
          options << "-c '#{root}'" if root
        end
      end
    end
  end
end
