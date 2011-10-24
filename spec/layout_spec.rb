require File.join(File.dirname(__FILE__), "spec_helper.rb")

describe Teamocil::Layout do

  context "compiling" do

    before do # {{{
      @layout = Teamocil::Layout.new(layouts["two-windows"], {})
    end # }}}

    it "creates windows" do # {{{
      session = @layout.compile!
      session.windows.each do |window|
        window.should be_an_instance_of Teamocil::Layout::Window
      end
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

    it "creates splits" do # {{{
      session = @layout.compile!
      session.windows.first.splits.each do |split|
        split.should be_an_instance_of Teamocil::Layout::Split
      end
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

    it "should handle blank filters" do # {{{
      session = @layout.compile!
      session.windows.first.filters.should have_key "after"
      session.windows.first.filters.should have_key "before"
      session.windows.first.filters["after"].should be_empty
      session.windows.first.filters["before"].should be_empty
    end # }}}

    it "should handle splits without a target" do # {{{
      session = @layout.compile!
      session.windows.last.splits.last.target.should == nil
    end # }}}

    it "should handle splits with a target" do # {{{
      session = @layout.compile!
      session.windows.last.splits.first.target.should == "bottom-right"
    end # }}}

    it "should handle windows within a session" do # {{{
      layout = Teamocil::Layout.new(layouts["three-windows-within-a-session"], {})
      session = layout.compile!
      session.windows.length.should == 3
      session.name.should == "my awesome session"
    end # }}}

  end

end
