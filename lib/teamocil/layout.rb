module Teamocil
  class Layout < ClosedStruct.new(:path)
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
      Teamocil.system("${EDITOR:-vi} #{path}")
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
      session.as_tmux.map { |command| "tmux #{command}" }
    end

    def session
      Teamocil::Tmux::Session.new(parsed_content)
    end

    def parsed_content
      YAML.load(raw_content)
    rescue Psych::SyntaxError
      raise Teamocil::Error::InvalidYAMLLayout, path
    end

    def raw_content
      @raw_content ||= ERB.new(File.read(path)).result
    rescue Errno::ENOENT
      raise Teamocil::Error::LayoutNotFound, path
    end
  end
end
