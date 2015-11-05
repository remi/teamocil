module Teamocil
  module Tmux
    class Window < ClosedStruct.new(:index, :root, :focus, :layout, :name, :panes)
      def initialize(object)
        super

        # Make sure paths like `~/foo/bar` work
        self.root = File.expand_path(root) if root

        self.panes ||= []
        self.panes = panes.each_with_index.map do |pane, index|
          # Support single command instead of `commands` key in Hash
          pane = { commands: [pane] } if pane.is_a?(String)

          # Panes need to know their position
          pane.merge! index: index

          # Panes need to know the window root directory
          pane.merge! root: root

          # Panes need to know the window layout
          pane.merge! layout: layout

          # Panes need to know the window name
          pane.merge! name: name

          Teamocil::Tmux::Pane.new(pane)
        end
      end

      def as_tmux
        [].tap do |tmux|
          # Rename the current window or create a new one
          if Teamocil.options[:here] && first?
            if root
              first_pane_index = panes.first.internal_index
              tmux << Teamocil::Command::SendKeysToPane.new(index: first_pane_index, keys: %(cd "#{root}"))
              tmux << Teamocil::Command::SendKeysToPane.new(index: first_pane_index, keys: 'Enter')
            end

            tmux << Teamocil::Command::RenameWindow.new(name: name)
          else
            tmux << Teamocil::Command::NewWindow.new(name: name, root: root)
          end

          # Execute all panes commands
          tmux << panes.map(&:as_tmux).flatten

          # Set the focus on the right pane or the first one
          focused_pane = panes.find(&:focus)
          focused_index = focused_pane ? focused_pane.internal_index : "#{name}.#{Teamocil::Tmux::Pane.pane_base_index}"
          tmux << Teamocil::Command::SelectPane.new(index: focused_index)
        end.flatten
      end

      def internal_index
        index + self.class.window_base_index
      end

      def self.window_base_index
        @window_base_index ||= begin
          base_index = Teamocil::Tmux.option('base-index', default: 0)
          current_window_count = Teamocil::Tmux.window_count

          # If `--here` is specified, treat the current window as a new one
          current_window_count -= 1 if Teamocil.options[:here]

          base_index + current_window_count
        end
      end

    protected

      def first?
        index.zero?
      end
    end
  end
end
