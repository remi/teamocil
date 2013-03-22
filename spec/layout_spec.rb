# encoding: utf-8
require File.join(File.dirname(__FILE__), "spec_helper.rb")

describe Teamocil::Layout do
  let(:window_pane_base_index) { 0 }
  before { Teamocil::Layout::Window.any_instance.stub(:pane_base_index).and_return(window_pane_base_index) }

  context "compiling" do
    before do
      @layout = Teamocil::Layout.new(layouts["two-windows"], {})
    end

    describe "handles bad layouts" do
      it "does not compile without windows" do
        @layout = Teamocil::Layout.new({ "name" => "foo" }, {})
        expect { @layout.compile! }.to raise_error Teamocil::Error::LayoutError
      end

      it "does not compile without splits" do
        @layout = Teamocil::Layout.new({ "windows" => [{ "name" => "foo" }] }, {})
        expect { @layout.compile! }.to raise_error Teamocil::Error::LayoutError
      end

      it "does not compile with empty splits" do
        @layout = Teamocil::Layout.new({ "windows" => [{ "name" => "foo", "splits" => [nil, nil] }] }, {})
        expect { @layout.compile! }.to raise_error Teamocil::Error::LayoutError
      end
    end

    describe "windows" do
      it "creates windows" do
        session = @layout.compile!
        session.windows.each do |window|
          window.should be_an_instance_of Teamocil::Layout::Window
        end
      end

      it "creates windows with names" do
        session = @layout.compile!
        session.windows[0].name.should == "foo"
        session.windows[1].name.should == "bar"
      end

      it "creates windows with root paths" do
        session = @layout.compile!
        session.windows[0].root.should == "/foo"
        session.windows[1].root.should == "/bar"
      end

      it "creates windows with clear option" do
        session = @layout.compile!
        session.windows[0].clear.should == "clear"
        session.windows[1].clear.should be_nil
      end

      it "creates windows with layout option" do
        session = @layout.compile!
        session.windows[0].layout.should == "tiled"
        session.windows[1].layout.should be_nil
      end
    end

    describe "splits" do
      it "creates splits" do
        session = @layout.compile!
        session.windows.first.splits.each do |split|
          split.should be_an_instance_of Teamocil::Layout::Split
        end
      end

      it "creates splits with dimensions" do
        session = @layout.compile!
        session.windows.first.splits[0].width.should == nil
        session.windows.first.splits[1].width.should == 50
      end

      it "creates splits with commands specified in strings" do
        session = @layout.compile!
        session.windows.first.splits[0].cmd.should == "echo 'foo'"
      end

      it "creates splits with commands specified in an array" do
        session = @layout.compile!
        session.windows.last.splits[0].cmd.length.should == 2
        session.windows.last.splits[0].cmd.first.should == "echo 'bar'"
        session.windows.last.splits[0].cmd.last.should == "echo 'bar in an array'"
      end

      it "handles focused splits" do
        session = @layout.compile!
        session.windows.last.splits[1].focus.should be_true
        session.windows.last.splits[0].focus.should be_false
      end
    end

    describe "filters" do
      it "creates windows with before filters" do
        layout = Teamocil::Layout.new(layouts["two-windows-with-filters"], {})
        session = layout.compile!
        session.windows.first.filters["before"].length.should == 2
        session.windows.first.filters["before"].first.should == "echo first before filter"
        session.windows.first.filters["before"].last.should == "echo second before filter"
      end

      it "creates windows with after filters" do
        layout = Teamocil::Layout.new(layouts["two-windows-with-filters"], {})
        session = layout.compile!
        session.windows.first.filters["after"].length.should == 2
        session.windows.first.filters["after"].first.should == "echo first after filter"
        session.windows.first.filters["after"].last.should == "echo second after filter"
      end

      it "should handle blank filters" do
        session = @layout.compile!
        session.windows.first.filters.should have_key "after"
        session.windows.first.filters.should have_key "before"
        session.windows.first.filters["after"].should be_empty
        session.windows.first.filters["before"].should be_empty
      end
    end

    describe "targets" do
      it "should handle splits without a target" do
        session = @layout.compile!
        session.windows.last.splits.last.target.should == nil
      end

      it "should handle splits with a target" do
        session = @layout.compile!
        session.windows.last.splits.first.target.should == "bottom-right"
      end
    end

    describe "sessions" do
      it "should handle windows within a session" do
        layout = Teamocil::Layout.new(layouts["three-windows-within-a-session"], {})
        session = layout.compile!
        session.windows.length.should == 3
        session.name.should == "my awesome session"
      end
    end
  end

  context "generating commands" do
    before { @layout = Teamocil::Layout.new(layouts["two-windows"], {}) }

    it "should generate split commands" do
      session = @layout.compile!
      commands = session.windows.last.splits[0].generate_commands
      commands.length.should == 2
      commands.first.should == "tmux send-keys -t 0 \"export TEAMOCIL=1; set -gx TEAMOCIL 1; cd \"/bar\"; echo 'bar'; echo 'bar in an array'\""
      commands.last.should == "tmux send-keys -t 0 Enter"

      session = @layout.compile!
      commands = session.windows.first.splits[0].generate_commands
      commands.length.should == 2
      commands.first.should == "tmux send-keys -t 0 \"export TEAMOCIL=1; set -gx TEAMOCIL 1; cd \"/foo\"; clear; echo 'foo'\""
      commands.last.should == "tmux send-keys -t 0 Enter"
    end

    it "should generate window commands" do
      session = @layout.compile!
      commands = session.windows.last.generate_commands
      commands.first.should == "tmux new-window -n \"bar\""
      commands.last.should == "tmux select-pane -t 1"
    end

    context "with custom pane-base-index option" do
      let(:window_pane_base_index) { 2 }

      it "should generate split commands" do
        session = @layout.compile!
        commands = session.windows.last.splits[0].generate_commands
        commands.length.should == 2
        commands.first.should == "tmux send-keys -t 2 \"export TEAMOCIL=1; set -gx TEAMOCIL 1; cd \"/bar\"; echo 'bar'; echo 'bar in an array'\""
        commands.last.should == "tmux send-keys -t 2 Enter"
      end
    end
  end
end
