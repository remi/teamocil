module Teamocil
  class Layout < ClosedStruct.new(:path, :options)
    def execute!
      if Teamocil.options[:debug]
        Teamocil.puts(shell_commands.join("\n"))
      else
        Teamocil.system(shell_commands.join('; '))
      end
    end

    def show!
      Teamocil.puts(raw_content)
    end

    def edit!
      Teamocil.system("$EDITOR #{path}")
    end

    def self.print_available_layouts(directory: nil)
      files = Dir.glob(File.join(directory, '*.yml'))

      files.map! do |file|
        extname = File.extname(file)
        File.basename(file).gsub(extname, '')
      end

      # Always return files in alphabetical order, even if `Dir.glob` almost
      # always does it
      files.sort!

      Teamocil.puts(files)
    end

  private

    def shell_commands
      commands = parsed_layout.as_tmux
      commands.flatten.map { |command| "tmux #{command}" }
    end

    def parsed_layout
      begin
        yaml_content = YAML.load(raw_content)
      rescue
        Teamocil.bail("There was a YAML error when parsing `#{path}`")
      end

      if valid?
        Teamocil::Tmux::Session.new(yaml_content)
      else
        Teamocil.bail("The layout at `#{path}` is not valid.")
      end
    end

    def valid?
      # TODO: Actually validate if the layout is valid
      true
    end

    def raw_content
      File.read(path)
    rescue
      Teamocil.bail("Cannot find a layout at `#{path}`")
    end
  end
end
