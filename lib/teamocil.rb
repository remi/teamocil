require 'yaml'

$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module Teamocil
  VERSION = '0.1'
  autoload :Layout, "teamocil/layout"
end
