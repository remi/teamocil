module Teamocil
  module Command
    class NewWindow < ClosedStruct.new(:name, :root)
      def to_s
        "new-window #{options.join(' ')}"
      end

      def options
        [].tap do |options|
          options << "-n '#{name}'" if name
          options << "-c '#{root}'" if root
        end
      end
    end
  end
end
