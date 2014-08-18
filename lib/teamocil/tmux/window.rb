module Teamocil
  module Tmux
    class Window < ClosedStruct.new(:index, :root, :focus, :layout, :name, :panes, :first)
      def initialize(object)
        super

        # Make sure paths like `~/foo/bar` work
        self.root = File.expand_path(root) if root

        self.panes ||= splits
        self.panes = panes.each_with_index.map do |pane, index|
          # Support single command instead of `commands` key in Hash
          pane = { commands: [pane] } if pane.is_a?(String)

          # Panes need to know their position
          pane.merge! index: index + pane_base_index
          pane.merge! first: index.zero?

          # Panes need know the window root directory
          pane.merge! root: root

          Teamocil::Tmux::Pane.new(pane)
        end
      end

      def as_tmux
        [].tap do |tmux|
          # Rename the current window or create a new one
          if Teamocil.options[:here] && first
            tmux << Teamocil::Command::RenameWindow.new(name: name)
          else
            tmux << Teamocil::Command::NewWindow.new(name: name, root: root)
          end

          # Execute all panes commands
          tmux << panes.map(&:as_tmux)

          # Select the window layout
          tmux << Teamocil::Command::SelectLayout.new(layout: layout) if layout

          # Set the focus on the right pane or the first one
          focused_pane = panes.find(&:focus)
          focused_index = focused_pane ? focused_pane.index : pane_base_index
          tmux << Teamocil::Command::SelectPane.new(index: focused_index)
        end
      end

      def pane_base_index
        @pane_base_index ||= Teamocil::Tmux::Options.fetch_window_option('pane-base-index', default: 0)
      end
    end
  end
end
