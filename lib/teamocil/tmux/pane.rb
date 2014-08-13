module Teamocil
  module Tmux
    class Pane < ClosedStruct.new(:index, :root, :commands, :focus, :first)
      def as_tmux
        [].tap do |tmux|
          tmux << Teamocil::Command::SplitWindow.new(root: root) unless first
          tmux << Teamocil::Command::SendKeysToPane.new(index: index, keys: commands.join('; '))
          tmux << Teamocil::Command::SendKeysToPane.new(index: index, keys: 'Enter')
        end
      end
    end
  end
end
