$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require 'yaml'
require 'teamocil'

module Helpers

  def examples # {{{
    return @@examples if defined?(@@examples)
    @@examples = YAML.load_file(File.join(File.dirname(__FILE__), "examples/layouts.yml"))
  end # }}}

end

RSpec.configure do |c|
  c.include Helpers
end
