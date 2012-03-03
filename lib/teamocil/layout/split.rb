module Teamocil
  class Layout

    # This class represents a split within a tmux window
    class Split
      attr_reader :width, :height, :cmd, :index, :target

      # Initialize a new tmux split
      #
      # @param session [Session] the window where the split is initialized
      # @param index [Fixnnum] the split index
      # @param attrs [Hash] the split data from the layout file
      def initialize(window, index, attrs={}) # {{{
        @height = attrs["height"]
        @width = attrs["width"]
        @cmd = attrs["cmd"]
        @target = attrs["target"]

        @window = window
        @index = index
      end # }}}

      # Generate commands to send to tmux
      #
      # @return [Array]
      def generate_commands # {{{
        commands = []

        # Is it a vertical or horizontal split?
        init_command = ""
        unless @index == 0
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
        @cmd = [@window.filters["before"]] + [@cmd] + [@window.filters["after"]]

        # If a `root` key exist, start each split in this directory
        @cmd.unshift "cd \"#{@window.root}\"" unless @window.root.nil?

        # Execute each split command
        @cmd.flatten.compact.each do |command|
          commands << "tmux send-keys -t #{@index} \"#{command}\""
          commands << "tmux send-keys -t #{@index} Enter"
        end

        commands
      end # }}}

    end

  end
end
