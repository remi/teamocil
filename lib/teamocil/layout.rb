module Teamocil

  # This class act as a wrapper around a tmux YAML layout file
  class Layout
    autoload :Session, "teamocil/layout/session"
    autoload :Window,  "teamocil/layout/window"
    autoload :Split,   "teamocil/layout/split"

    attr_reader :session

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
