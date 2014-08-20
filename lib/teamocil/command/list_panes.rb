module Teamocil
  module Command
    class ListPanes < ClosedStruct.new(:index)
      def to_s
        "list-panes #{options.join(' ')}"
      end

      def options
        [].tap do |options|
          options << "-t '#{index}'" if index
        end
      end
    end
  end
end
