module Teamocil

  # This class act as a wrapper around a tmux YAML layout file
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
        @windows = attrs["windows"].each_with_index.map { |window, index| Window.new(self, index, window) }
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

    # This class represents a window within tmux
    class Window
      attr_reader :filters, :root, :splits, :options, :index, :name

      # Initialize a new tmux window
      #
      # @param session [Session] the session where the window is initialized
      # @param index [Fixnnum] the window index
      # @param attrs [Hash] the window data from the layout file
      def initialize(session, index, attrs={}) # {{{
        @name = attrs["name"]
        @root = attrs["root"]
        @options = attrs["options"]
        @filters = attrs["filters"]
        @splits = attrs["splits"].each_with_index.map { |split, index| Split.new(self, index, split) }
        @index = index
        @session = session

        @options ||= {}
        @filters ||= {}
        @filters["before"] ||= []
        @filters["after"] ||= []
      end # }}}

      # Generate commands to send to tmux
      #
      # @return [Array]
      def generate_commands # {{{
        commands = []

        if @session.options.include?(:here) and @index == 0
          commands << "tmux rename-window \"#{@name}\""
        else
          commands << "tmux new-window -n \"#{@name}\""
        end

        commands << @splits.map(&:generate_commands)

        @options.each_pair do |option, value|
          value = "on"  if value === true
          value = "off" if value === false
          commands << "tmux set-window-option #{option} #{value}"
        end

        commands
      end # }}}

    end

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
        unless @index == 0
          if !@width.nil?
            commands << "tmux split-window -h -p #{@width}"
          elsif !@height.nil?
            commands << "tmux split-window -p #{@height}"
          else
            commands << "tmux split-window"
          end
          commands << " -t #{@target}" unless @target.nil?
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

    # Initialize a new layout from a hash
    #
    # @param layout [Hash] the parsed layout
    # @param options [Hash] some options
    def initialize(layout, options={}) # {{{
      @layout = layout
      @options = options
    end # }}}

    # Generate tmux commands based on the data found in the layout file
    #
    # @return [Array] an array of shell commands to send
    def generate_commands # {{{
      @session.generate_commands
    end # }}}

    # Compile the layout into objects
    #
    # @return [Session]
    def compile! # {{{
      if @layout["session"].nil?
        @session = Session.new @options, "windows" => @layout["windows"]
      else
        @session = Session.new @options, @layout["session"]
      end
    end # }}}

    # Execute each command in the shell
    #
    # @param commands [Array] an array of complete commands to send to the shell
    def execute_commands(commands) # {{{
      `#{commands.join("; ")}`
    end # }}}

  end
end
