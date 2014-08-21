module Teamocil
  module Error
    class InvalidYAMLLayout < StandardError
      def initialize(path)
        @path = path
      end

      def to_s
        "There was a YAML error when parsing `#{@path}`"
      end
    end
  end
end
