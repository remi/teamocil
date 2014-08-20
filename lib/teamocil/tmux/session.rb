module Teamocil
  module Tmux
    class Session < ClosedStruct.new(:name, :windows)
      def initialize(object)
        super

        # Sessions need a name
        self.name = "teamocil-session-#{rand(1_000_000)}" unless name

        self.windows = windows.each_with_index.map do |window, index|
          # Windows need to know their position
          window.merge! index: index + window_base_index
          window.merge! first: index.zero?

          Teamocil::Tmux::Window.new(window)
        end
      end

      def as_tmux
        [].tap do |tmux|
          tmux << Teamocil::Command::RenameSession.new(name: name)
          tmux << windows.map(&:as_tmux)

          # Set the focus on the right window or do nothing
          focused_window = windows.find(&:focus)
          tmux << Teamocil::Command::SelectWindow.new(index: focused_window.index) if focused_window
        end
      end

      def window_base_index
        @window_base_index ||= begin
          base_index = Teamocil::Tmux.option('base-index', default: 0)
          current_window_count = Teamocil::Tmux.window_count

          # If `--here` is specified, treat the current window as a new one
          current_window_count -= 1 if Teamocil.options[:here]

          base_index + current_window_count
        end
      end
    end
  end
end
