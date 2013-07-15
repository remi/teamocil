module Teamocil
  class Layout
    # This class represents a pane within a tmux window
    class Pane
      attr_reader :width, :height, :cmd, :index, :target, :focus

      # Initialize a new tmux pane
      #
      # @param session [Session] the window where the pane is initialized
      # @param index [Fixnnum] the pane index
      # @param attrs [Hash] the pane data from the layout file
      def initialize(window, index, attrs={})
        raise Teamocil::Error::LayoutError.new("You cannot have empty panes") if attrs.nil?
        @height = attrs["height"]
        @width = attrs["width"]
        @cmd = attrs["cmd"]
        @target = attrs["target"]
        @focus = attrs["focus"] || false

        @window = window
        @index = index
      end

      # Generate commands to send to tmux
      #
      # @return [Array]
      def generate_commands
        commands = []

        # Is it a vertical or horizontal pane
        init_command = ""
        unless @index == @window.pane_base_index
          if !@width.nil?
            init_command = "tmux split-window -h -p #{@width}"
          elsif !@height.nil?
            init_command = "tmux split-window -p #{@height}"
          else
            init_command = "tmux split-window"
          end
          init_command << " -t #{@target}" unless @target.nil?
          commands << init_command
        end

        # Wrap all commands around filters
        @cmd = [@window.filters["before"]] + [@window.clear] + [@cmd] + [@window.filters["after"]]

        # If a `root` key exist, start each pane in this directory
        @cmd.unshift "cd \"#{@window.root}\"" unless @window.root.nil?

        # Set the TEAMOCIL environment variable
        # depending on the shell set in ENV
        if ENV['SHELL'].scan(/fish/).empty?
          @cmd.unshift "export TEAMOCIL=1" if @window.with_env_var
        else
          @cmd.unshift "set -gx TEAMOCIL 1"
        end

        # Execute each pane command
        commands << "tmux send-keys -t #{@index} \"#{@cmd.flatten.compact.join(@window.cmd_separator)}\""
        commands << "tmux send-keys -t #{@index} Enter"

        commands
      end
    end
  end
end
