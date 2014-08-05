module Teamocil
  class Window < ClosedStruct.new(:index, :root, :focus, :layout, :name, :panes)
    def initialize(object)
      super

      self.panes ||= splits
      self.panes = panes.each_with_index.map do |pane, index|
        # Support single command instead of `commands` key in Hash
        pane = { commands: [pane] } if pane.is_a?(String)

        # Panes need to know their position
        pane.merge! index: index + 1

        # Panes need know the window root directory
        pane.merge! root: root

        Pane.new(pane)
      end
    end

    def first?
      index == 1
    end

    def as_tmux
      [].tap do |tmux|
        # Rename the current window or create a new one
        if Teamocil.options[:here] && first?
          tmux << Command::RenameWindow.new(name: name)
        else
          tmux << Command::NewWindow.new(name: name, root: root)
        end

        # Execute all panes commands
        tmux << panes.map(&:as_tmux)

        # Select the window layout
        tmux << Command::SelectLayout.new(layout: layout)

        # Set the focus on the right pane or the first one
        focused_pane = panes.find(&:focus)
        focused_index = focused_pane ? focused_pane.index : 0
        tmux << Command::SelectPane.new(index: focused_index)
      end
    end
  end
end
