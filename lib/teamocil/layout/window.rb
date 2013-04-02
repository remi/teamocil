module Teamocil
  class Layout
    # This class represents a window within tmux
    class Window
      attr_reader :filters, :root, :panes, :options, :index, :name, :clear, :layout

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

        @panes = attrs["panes"] || attrs["splits"] || []
        raise Teamocil::Error::LayoutError.new("You must specify a `panes` (or legacy `splits`) key for every window.") if @panes.empty?
        @panes = @panes.each_with_index.map { |pane, pane_index| Pane.new(self, pane_index + pane_base_index, pane) }

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

        pane_commands = @panes.map do |pane|
          c = pane.generate_commands
          c << "tmux select-layout \"#{@layout}\"" if @layout
          c
        end
        commands << pane_commands

        @options.each_pair do |option, value|
          value = "on"  if value === true
          value = "off" if value === false
          commands << "tmux set-window-option #{option} #{value}"
        end

        commands << "tmux select-layout \"#{@layout}\"" if @layout
        commands << "tmux select-pane -t #{@panes.map(&:focus).index(true) || 0}"

        commands
      end

      # Return the `pane-base-index` option for the current window
      #
      # @return [Fixnum]
      def pane_base_index
        @pane_base_index ||= begin
          global_setting = `tmux show-window-options -g | grep pane-base-index`.split(/\s/).last
          local_setting = `tmux show-window-options | grep pane-base-index`.split(/\s/).last
          (local_setting || global_setting || "0").to_i
        end
      end
    end
  end
end
