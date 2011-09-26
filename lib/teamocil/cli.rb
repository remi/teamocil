require 'optparse'
require 'fileutils'

module Teamocil
  # This class handles interaction with the `tmux` utility.
  class CLI

    # Initialize a new run of `tmux`
    #
    # @param argv [Hash] the command line parameters hash (usually `ARGV`).
    # @param env [Hash] the environment variables hash (usually `ENV`).
    def initialize(argv, env) # {{{
      bail "You must be in a tmux session to use teamocil" unless env["TMUX"]

      parse_options!
      if @options.include?(:layout)
        file = options[:layout]
      else
        file = ::File.join("#{env["HOME"]}/.teamocil", "#{argv[0]}.yml")
      end

      if @options[:edit]
        ::FileUtils.touch file unless File.exists?(file)
        system("$EDITOR \"#{file}\"")
      else
        bail "There is no file \"#{file}\"" unless File.exists?(file)
        layout = Teamocil::Layout.new(file, @options)
        layout.to_tmux
      end
    end # }}}

    # Parse the command line options
    def parse_options! # {{{
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

        opts.on("--layout [LAYOUT]", "Use a specific layout file, instead of ~/.teamocil/<layout>.yml") do |layout|
          @options[:layout] = layout
        end

      end
      opts.parse!
    end # }}}

    # Print an error message and exit the utility
    #
    # @param msg [Mixed] something to print before exiting.
    def bail(msg) # {{{
      puts "[teamocil] #{msg}"
      exit 1
    end # }}}

  end
end
