module Teamocil
  module Command
    class SplitWindow < ClosedStruct.new(:root, :name)
      def to_s
        "split-window -t '#{name}' #{options.join(' ')}"
      end

      def options
        [].tap do |options|
          options << "-c '#{root}'" if root
        end
      end
    end
  end
end
