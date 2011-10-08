require File.join(File.dirname(__FILE__), "spec_helper.rb")

describe Teamocil::Layout do
  context "initializing" do

    it "create two windows" do # {{{
      layout = Teamocil::Layout.new(examples["two-windows"], {})
      commands = layout.generate_commands
      commands.grep(/new-window/).length.should be 2
    end # }}}

  end
end
