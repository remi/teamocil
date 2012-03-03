module Teamocil
  class Layout

    # This class represents a session within tmux
    class Session
      attr_reader :options, :windows, :name

      # Initialize a new tmux session
      #
      # @param options [Hash] the options, mostly passed by the CLI
      # @param attrs [Hash] the session data from the layout file
      def initialize(options, attrs={}) # {{{
        @name = attrs["name"]
        @windows = attrs["windows"].each_with_index.map { |window, window_index| Window.new(self, window_index, window) }
        @options = options
      end # }}}

      # Generate commands to send to tmux
      #
      # @return [Array]
      def generate_commands # {{{
        commands = []
        commands << "tmux rename-session \"#{@name}\"" unless @name.nil?
        commands << @windows.map(&:generate_commands)
        commands << "tmux select-pane -t 0"
        commands
      end # }}}

    end
  end
end
