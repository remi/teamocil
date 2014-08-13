module Teamocil
  module Tmux
    class Options
      def self.fetch_option(option, default: nil)
        value = Teamocil.query_system("tmux show-options -gv #{option}").chomp
        value.empty? ? default : value.to_i
      end

      def self.fetch_window_option(option, default: nil)
        value = Teamocil.query_system("tmux show-window-options -gv #{option}").chomp
        value.empty? ? default : value.to_i
      end
    end
  end
end
