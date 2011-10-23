require File.join(File.dirname(__FILE__), "spec_helper.rb")

describe Teamocil::Layout do
  context "initializing" do

    it "creates windows" do # {{{
      layout = Teamocil::Layout.new(layouts["two-windows"], {})
      commands = layout.generate_commands
      commands.grep(/new-window/).length.should == 2
    end # }}}

    it "renames the current session" do # {{{
      layout = Teamocil::Layout.new(layouts["two-windows-in-a-session"], {})
      commands = layout.generate_commands
      commands.grep(/rename-session/).first.should == "tmux rename-session \"my-new-session\""
      commands.grep(/new-window/).length.should == 2
    end # }}}

    it "creates splits" do # {{{
      layout = Teamocil::Layout.new(layouts["four-splits"], {})
      commands = layout.generate_commands
      commands.grep(/split-window/).length.should == 3
    end # }}}

  end
end
