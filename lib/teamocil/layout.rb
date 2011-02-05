module Teamocil
  class Layout

    attr_accessor :config, :name

    def initialize(name, file) # {{{
      @layout = YAML.load_file(file)
      @name = name
    end # }}}

    def to_tmux # {{{
      commands = generate_commands
      execute_commands(commands)
    end # }}}

    def generate_commands # {{{
      output = []

      @layout["windows"].each do |window|

        output << "tmux new-window -n #{window["name"]}"
        window["splits"].each_with_index do |split, index|
          unless index == 0
            if split.include?("width")
              output << "tmux split-window -h -p #{split["width"]}"
            else
              if split.include?("height")
                output << "tmux split-window -p #{split["height"]}"
              else
                output << "tmux split-window"
              end
            end
          end

          split["cmd"] = [split["cmd"]] unless split["cmd"].is_a? Array
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
