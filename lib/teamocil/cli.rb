require 'optparse'
require 'fileutils'

module Teamocil
  # This class handles interaction with the `tmux` utility.
  class CLI

    attr_accessor :layout, :layouts

    # Initialize a new run of `tmux`
    #
    # @param argv [Hash] the command line parameters hash (usually `ARGV`).
    # @param env [Hash] the environment variables hash (usually `ENV`).
    def initialize(argv, env) # {{{
      parse_options! argv
      layout_path = File.join("#{env["HOME"]}", ".teamocil")

      if @options.include?(:list)
        @layouts = get_layouts(layout_path)
        return print_layouts
      end

      if @options.include?(:layout)
        file = @options[:layout]
      else
        file = ::File.join(layout_path, "#{argv[0]}.yml")
      end

      if @options[:edit]
        ::FileUtils.touch file unless File.exists?(file)

        Kernel.system("$EDITOR \"#{file}\"")
      else
        bail "There is no file \"#{file}\"" unless File.exists?(file)
        bail "You must be in a tmux session to use teamocil" unless env["TMUX"]

        parsed_layout = YAML.load_file(file)
        @layout = Teamocil::Layout.new(parsed_layout, @options)
        @layout.compile!
        @layout.execute_commands(@layout.generate_commands)
      end
    end # }}}

    # Parse the command line options
    def parse_options!(args) # {{{
      @options = {}
      opts = ::OptionParser.new do |opts|
        opts.banner = "Usage: teamocil [options] <layout>

      Options:
        "
        opts.on("--here", "Set up the first window in the current window") do
          @options[:here] = true
        end

        opts.on("--edit", "Edit the YAML layout file instead of using it") do
          @options[:edit] = true
        end

        opts.on("--layout [LAYOUT]", "Use a specific layout file, instead of `~/.teamocil/<layout>.yml`") do |layout|
          @options[:layout] = layout
        end

        opts.on("--list", "List all available layouts in `~/.teamocil/`") do
          @options[:list] = true
        end

      end
      opts.parse! args
    end # }}}

    # Return an array of available layouts
    #
    # @param path [String] the path used to look for layouts
    def get_layouts(path) # {{{
      Dir.glob(File.join(path, "*.yml")).map { |file| File.basename(file).gsub(/\..+$/, "") }.sort
    end # }}}

    # Print each layout on a single line
    def print_layouts # {{{
      STDOUT.puts @layouts.join("\n")
      exit 0
    end # }}}

    # Print an error message and exit the utility
    #
    # @param msg [Mixed] something to print before exiting.
    def bail(msg) # {{{
      STDERR.puts "[teamocil] #{msg}"
      exit 1
    end # }}}

  end
end
