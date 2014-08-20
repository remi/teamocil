$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

# We need `Dir.tmpdir`
require 'tmpdir'

# RSpec testing framework
require 'rspec'

# Teamocil
require 'teamocil'

RSpec.configure do |config|
  # Disable `should` syntax
  config.expect_with(:rspec) { |c| c.syntax = :expect }
end
