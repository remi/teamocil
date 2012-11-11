module Teamocil
  class Layout

    # This class represents a window within tmux
    class Window
      attr_reader :filters, :root, :splits, :options, :index, :name, :clear, :layout

      # Initialize a new tmux window
      #
      # @param session [Session] the session where the window is initialized
      # @param index [Fixnnum] the window index
      # @param attrs [Hash] the window data from the layout file
      def initialize(session, index, attrs={})
        @name = attrs["name"] || "teamocil-window-#{index+1}"
        @root = attrs["root"] || "."
        @clear = attrs["clear"] == true ? "clear" : nil
        @options = attrs["options"] || {}
        @layout = attrs["layout"]

        @splits = attrs["splits"] || []
        raise Teamocil::Error::LayoutError.new("You must specify a `splits` key for every window.") if @splits.empty?
        @splits = @splits.each_with_index.map { |split, split_index| Split.new(self, split_index, split) }

        @filters = attrs["filters"] || {}
        @filters["before"] ||= []
        @filters["after"] ||= []

        @index = index
        @session = session
      end

      # Generate commands to send to tmux
      #
      # @return [Array]
      def generate_commands
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

        commands << "tmux select-layout \"#{@layout}\"" if @layout
        commands << "tmux select-pane -t #{@splits.map(&:focus).index(true) || 0}"

        commands
      end

    end

  end
end
