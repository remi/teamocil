module Teamocil
  module Error
    class LayoutNotFound < StandardError
      def initialize(path)
        @path = path
      end

      def to_s
        "Cannot find a layout at `#{@path}`"
      end
    end
  end
end
