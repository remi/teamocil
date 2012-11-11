$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require 'yaml'
require 'teamocil'
require File.join(File.dirname(__FILE__), "./mock/layout.rb")
require File.join(File.dirname(__FILE__), "./mock/cli.rb")

module Helpers
  def layouts
    return @@examples if defined?(@@examples)
    @@examples = YAML.load_file(File.join(File.dirname(__FILE__), "fixtures/layouts.yml"))
  end
end

RSpec.configure do |c|
  c.include Helpers
end
