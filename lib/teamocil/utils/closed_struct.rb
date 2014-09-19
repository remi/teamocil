module Teamocil
  class ClosedStruct < Struct
    def initialize(*args)
      args = [{}] unless args.any?

      args.first.each_pair do |key, value|
        # Make sure we only set values to defined arguments
        if members.map(&:intern).include?(key.to_sym)
          send "#{key}=", value
        else
          raise ArgumentError, "#{self.class.name} doesn’t support the `#{key}` keyword, only #{members.join(', ')}"
        end
      end
    end
  end
end
