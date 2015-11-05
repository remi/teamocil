module Teamocil
  module Tmux
    class Pane < ClosedStruct.new(:index, :root, :commands, :focus, :layout, :name)
      def as_tmux
        [].tap do |tmux|
          tmux << Teamocil::Command::SplitWindow.new(root: root, name: name) unless first?
          tmux << Teamocil::Command::SendKeysToPane.new(index: internal_index, keys: commands.join('; ')) if commands
          tmux << Teamocil::Command::SendKeysToPane.new(index: internal_index, keys: 'Enter')
          tmux << Teamocil::Command::SelectLayout.new(layout: layout, name: name) if layout
        end
      end

      def internal_index
        "#{name}.#{index + self.class.pane_base_index}"
      end

      def self.pane_base_index
        @pane_base_index ||= Teamocil::Tmux.window_option('pane-base-index', default: 0)
      end

    private

      def first?
        index.zero?
      end
    end
  end
end
