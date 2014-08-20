module Teamocil
  module Tmux
    def self.option(option, default: nil)
      command = Teamocil::Command::ShowOptions.new(name: option)
      value = Teamocil.query_system(command).chomp
      value.empty? ? default : value.to_i
    end

    def self.window_option(option, default: nil)
      command = Teamocil::Command::ShowWindowOptions.new(name: option)
      value = Teamocil.query_system(command).chomp
      value.empty? ? default : value.to_i
    end

    def self.window_count
      command = Teamocil::Command::ListWindows.new
      Teamocil.query_system(command).chomp.split("\n").size
    end

    def self.pane_count(index: nil)
      command = Teamocil::Command::ListPanes.new(index: index)
      Teamocil.query_system(command).chomp.split("\n").size
    end
  end
end
