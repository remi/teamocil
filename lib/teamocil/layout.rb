module Teamocil
  # This class act as a wrapper around a tmux YAML layout file.
  class Layout

    # Initialize a new layout from a hash
    #
    # @param layout [Hash] the parsed layout
    # @param options [Hash] some options
    def initialize(layout, options={}) # {{{
      @layout = layout
      @options = options
    end # }}}

    # Generate commands and sends them to tmux
    def to_tmux # {{{
      commands = generate_commands
      execute_commands(commands)
    end # }}}

    # Generate tmux commands based on the data found in the layout file
    #
    # @return [Array] an array of shell commands to send
    def generate_commands # {{{
      output = []

      # Support renaming of current session
      if @layout["session"].nil?
        windows = @layout["windows"]
      else
        output << "tmux rename-session \"#{@layout["session"]["name"]}\"" if @layout["session"]["name"]
        windows = @layout["session"]["windows"]
      end

      windows.each_with_index do |window, window_index|

        # Create a new window unless we used the `--here` option
        if @options.include?(:here) and window_index == 0
          output << "tmux rename-window \"#{window["name"]}\""
        else
          output << "tmux new-window -n \"#{window["name"]}\""
        end

        # Make sure we have all the keys we need
        window["options"] ||= {}
        window["filters"] ||= {}
        window["filters"]["before"] ||= []
        window["filters"]["after"] ||= []

        # Create splits
        window["splits"].each_with_index do |split, split_index|
          unless split_index == 0
            if split.include?("width")
              cmd = "tmux split-window -h -p #{split["width"]}"
            elsif split.include?("height")
              cmd = "tmux split-window -p #{split["height"]}"
            else
              cmd = "tmux split-window"
            end
            cmd << " -t #{split["target"]}" if split.include?("target")
            output << cmd
          end

          # Wrap all commands around filters
          split["cmd"] = [window["filters"]["before"]] + [split["cmd"]] + [window["filters"]["after"]]

          # If a `root` key exist, start each split in this directory
          split["cmd"].unshift "cd \"#{window["root"]}\"" if window.include?("root")

          # Execute each split command
          split["cmd"].flatten.compact.each do |command|
            output << "tmux send-keys -t #{split_index} \"#{command}\""
            output << "tmux send-keys -t #{split_index} Enter"
          end
        end

        # Set tmux options
        window["options"].each_pair do |option, value|
          value = "on"  if value === true
          value = "off" if value === false
          output << "tmux set-window-option #{option} #{value}"
        end

      end

      # Set the focus in the first split
      output << "tmux select-pane -t 0"
    end # }}}

    # Execute each command in the shell
    #
    # @param commands [Array] an array of complete commands to send to the shell
    def execute_commands(commands) # {{{
      `#{commands.join("; ")}`
    end # }}}

  end
end
