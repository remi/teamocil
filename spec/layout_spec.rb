require File.join(File.dirname(__FILE__), "spec_helper.rb")

describe Teamocil::Layout do

  context "initializing" do
  end

  context "compiling" do

    before :each do # {{{
      @layout = Teamocil::Layout.new(layouts["two-windows"], {})
    end # }}}

    it "creates windows with names" do # {{{
      session = @layout.compile!
      session.windows[0].name.should == "foo"
      session.windows[1].name.should == "bar"
    end # }}}

    it "creates windows with root paths" do # {{{
      session = @layout.compile!
      session.windows[0].root.should == "/foo"
      session.windows[1].root.should == "/bar"
    end # }}}

    it "creates splits with dimensions" do # {{{
      session = @layout.compile!
      session.windows.first.splits[0].width.should == nil
      session.windows.first.splits[1].width.should == 50
    end # }}}

    it "creates splits with commands specified in strings" do # {{{
      session = @layout.compile!
      session.windows.first.splits[0].cmd.should == "echo 'foo'"
    end # }}}

    it "creates splits with commands specified in an array" do # {{{
      session = @layout.compile!
      session.windows.last.splits[0].cmd.length.should == 2
      session.windows.last.splits[0].cmd.first.should == "echo 'bar'"
      session.windows.last.splits[0].cmd.last.should == "echo 'bar in an array'"
    end # }}}

    it "creates windows with before filters" do # {{{
      layout = Teamocil::Layout.new(layouts["two-windows-with-filters"], {})
      session = layout.compile!
      session.windows.first.filters["before"].length.should == 2
      session.windows.first.filters["before"].first.should == "echo first before filter"
      session.windows.first.filters["before"].last.should == "echo second before filter"
    end # }}}

    it "creates windows with after filters" do # {{{
      layout = Teamocil::Layout.new(layouts["two-windows-with-filters"], {})
      session = layout.compile!
      session.windows.first.filters["after"].length.should == 2
      session.windows.first.filters["after"].first.should == "echo first after filter"
      session.windows.first.filters["after"].last.should == "echo second after filter"
    end # }}}

  end
end
