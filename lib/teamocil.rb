require 'erb'
require 'yaml'
require 'optparse'

# Version
require 'teamocil/version'

# Utils
require 'teamocil/utils/closed_struct'
require 'teamocil/utils/option_parser'

# Teamocil
require 'teamocil/layout'
require 'teamocil/cli'

# Errors
require 'teamocil/error/layout_not_found'
require 'teamocil/error/invalid_yaml_layout'

# Command classes
require 'teamocil/command/list_panes'
require 'teamocil/command/list_windows'
require 'teamocil/command/new_window'
require 'teamocil/command/rename_session'
require 'teamocil/command/rename_window'
require 'teamocil/command/select_layout'
require 'teamocil/command/select_pane'
require 'teamocil/command/select_window'
require 'teamocil/command/send_keys'
require 'teamocil/command/send_keys_to_pane'
require 'teamocil/command/set_window_option'
require 'teamocil/command/show_options'
require 'teamocil/command/show_window_options'
require 'teamocil/command/split_window'

# Tmux classes
require 'teamocil/tmux'
require 'teamocil/tmux/session'
require 'teamocil/tmux/window'
require 'teamocil/tmux/pane'

module Teamocil
  class << self
    attr_reader :options
  end

  def self.bail(*args)
    print '[teamocil error] '
    puts(*args)
    exit
  end

  def self.puts(*args)
    STDOUT.puts(*args)
  end

  def self.system(*args)
    Kernel.system(*args)
  end

  def self.query_system(command)
    `tmux #{command.to_s}`
  end

  def self.parse_options!(arguments: nil)
    parser = OptionParser.new(arguments: arguments)
    @options = parser.parsed_options
  end
end
