module Teamocil
  class Layout

    attr_accessor :layout, :options

    def initialize(file, options) # {{{
      @layout = YAML.load_file(file)
      @options = options
    end # }}}

    def to_tmux # {{{
      commands = generate_commands
      execute_commands(commands)
    end # }}}

    def generate_commands # {{{
      output = []

      if @layout["session"].nil?
        windows = @layout["windows"]
      else
        output << "tmux rename-session #{@layout["session"]["name"]}" if @layout["session"]["name"]
        windows = @layout["session"]["windows"]
      end

      windows.each_with_index do |window, window_index|

        if options.include?(:here) and window_index == 0
          output << "tmux rename-window \"#{window["name"]}\""
        else
          output << "tmux new-window -n \"#{window["name"]}\""
        end

        window["splits"].each_with_index do |split, index|
          unless index == 0
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

          # Support single command splits, but treat it as an array nevertheless
          split["cmd"] = [split["cmd"]] unless split["cmd"].is_a? Array

          # If a `root` key exist, start each split in this directory
          split["cmd"] = ["cd \"#{window["root"]}\""] + split["cmd"] if window.include?("root")

          # Execute each split command
          split["cmd"].each do |command|
            output << "tmux send-keys -t #{index} \"#{command}\""
            output << "tmux send-keys -t #{index} Enter"
          end
        end

      end

      output << "tmux select-pane -t 0"
    end # }}}

    def execute_commands(commands) # {{{
      `#{commands.join("; ")}`
    end # }}}

  end
end
