# encoding: utf-8
require File.join(File.dirname(__FILE__), "spec_helper.rb")

describe Teamocil::CLI do
  let(:window_pane_base_index) { 0 }
  before { Teamocil::Layout::Window.any_instance.stub(:pane_base_index).and_return(window_pane_base_index) }

  context "executing" do
    before do
      @fake_env = { "TMUX" => 1, "HOME" => File.join(File.dirname(__FILE__), "fixtures") }
    end

    context "not in tmux" do
      it "should allow editing" do
        FileUtils.stub(:touch)
        Kernel.should_receive(:system).with("${EDITOR:-vim} #{File.join(@fake_env["HOME"], ".teamocil", "my-layout.yml").inspect}")
        Teamocil::CLI.new(["--edit", "my-layout"], @fake_env)
      end
    end

    context "in tmux" do
      before :each do
        Teamocil::CLI.messages = []
      end

      it "creates a layout from a name" do
        @cli = Teamocil::CLI.new(["sample"], @fake_env)
        @cli.layout.session.name.should == "sample"
        @cli.layout.session.windows.length.should == 2
        @cli.layout.session.windows.first.name.should == "foo"
        @cli.layout.session.windows.last.name.should == "bar"
      end

      it "fails to launch if no layout is provided" do
        expect { @cli = Teamocil::CLI.new([], @fake_env) }.to raise_error SystemExit
        Teamocil::CLI.messages.should include("You must supply a layout for teamocil to use. See `teamocil --help` for more options.")
      end

      it "fails to create a layout from a layout that doesn’t exist" do
        expect { @cli = Teamocil::CLI.new(["i-do-not-exist"], @fake_env) }.to raise_error SystemExit
        Teamocil::CLI.messages.should include("There is no file \"#{File.join(File.dirname(__FILE__), "fixtures", ".teamocil", "i-do-not-exist.yml")}\".")
      end

      it "creates a layout from a specific file" do
        @cli = Teamocil::CLI.new(["--layout", "./spec/fixtures/.teamocil/sample.yml"], @fake_env)
        @cli.layout.session.name.should == "sample"
        @cli.layout.session.windows.length.should == 2
        @cli.layout.session.windows.first.name.should == "foo"
        @cli.layout.session.windows.last.name.should == "bar"
      end

      it "fails to create a layout from a file that doesn’t exist" do
        expect { @cli = Teamocil::CLI.new(["--layout", "./spec/fixtures/.teamocil/i-do-not-exist.yml"], @fake_env) }.to raise_error SystemExit
        Teamocil::CLI.messages.should include("There is no file \"./spec/fixtures/.teamocil/i-do-not-exist.yml\".")
      end

      it "lists available layouts" do
        @cli = Teamocil::CLI.new(["--list"], @fake_env)
        @cli.layouts.should == ["sample", "sample-2"]
      end

      it "should show the content" do
        FileUtils.stub(:touch)
        Kernel.should_receive(:system).with("cat #{File.join(@fake_env["HOME"], ".teamocil", "sample.yml").inspect}")
        Teamocil::CLI.new(["--show", "sample"], @fake_env)
      end

      it "looks only in the $TEAMOCIL_PATH environment variable for layouts" do
        @fake_env = { "TMUX" => 1, "HOME" => File.join(File.dirname(__FILE__), "fixtures"), "TEAMOCIL_PATH" => File.join(File.dirname(__FILE__), "fixtures/.my-fancy-layouts-directory") }

        @cli = Teamocil::CLI.new(["sample-3"], @fake_env)
        @cli.layout.session.name.should == "sample-3"

        expect { @cli = Teamocil::CLI.new(["sample"], @fake_env) }.to raise_error SystemExit
        Teamocil::CLI.messages.should include("There is no file \"#{@fake_env["TEAMOCIL_PATH"]}/sample.yml\".")
      end
    end
  end
end
