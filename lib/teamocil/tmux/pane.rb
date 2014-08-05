module Teamocil
  class Pane < ClosedStruct.new(:index, :root, :commands, :focus)
    def as_tmux
      [].tap do |tmux|
        tmux << Command::SplitWindow.new(root: root) unless first?
        tmux << Command::SendKeysToPane.new(index: index, keys: commands.join('; '))
        tmux << Command::SendKeysToPane.new(index: index, keys: 'Enter')
      end
    end

    def first?
      index == 1
    end
  end
end
