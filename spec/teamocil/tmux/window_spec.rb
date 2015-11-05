require 'spec_helper'

RSpec.describe Teamocil::Tmux::Window do
  let(:window) { Teamocil::Tmux::Window.new(index: index, root: root, layout: layout, name: name, panes: panes) }
  let(:as_tmux) { window.as_tmux }

  before do
    allow(Teamocil::Tmux::Pane).to receive(:pane_base_index).and_return(pane_base_index)
    allow(Teamocil::Tmux::Window).to receive(:window_base_index).and_return(window_base_index)
    allow(Teamocil).to receive(:options).and_return(options)
  end

  # Tmux options
  let(:pane_base_index) { Random.rand(0..100) }
  let(:window_base_index) { Random.rand(0..100) }

  # Window attributes
  let(:options) { {} }
  let(:index) { 0 }
  let(:name) { 'foo' }
  let(:layout) { nil }
  let(:root) { nil }
  let(:panes) do
    [
      { commands: %w(foo omg) },
      { commands: %w(bar), focus: true }
    ]
  end

  it do
    expect(as_tmux).to eql [
      Teamocil::Command::NewWindow.new(name: name),
      Teamocil::Command::SendKeysToPane.new(index: "#{name}.#{pane_base_index}", keys: 'foo; omg'),
      Teamocil::Command::SendKeysToPane.new(index: "#{name}.#{pane_base_index}", keys: 'Enter'),
      Teamocil::Command::SplitWindow.new(name: name),
      Teamocil::Command::SendKeysToPane.new(index: "#{name}.#{pane_base_index + 1}", keys: 'bar'),
      Teamocil::Command::SendKeysToPane.new(index: "#{name}.#{pane_base_index + 1}", keys: 'Enter'),
      Teamocil::Command::SelectPane.new(index: "#{name}.#{pane_base_index + 1}")
    ]
  end

  context 'with root attribute' do
    let(:root) { '/tmp' }

    it do
      expect(as_tmux).to eql [
        Teamocil::Command::NewWindow.new(name: name, root: root),
        Teamocil::Command::SendKeysToPane.new(index: "#{name}.#{pane_base_index}", keys: 'foo; omg'),
        Teamocil::Command::SendKeysToPane.new(index: "#{name}.#{pane_base_index}", keys: 'Enter'),
        Teamocil::Command::SplitWindow.new(name: name, root: root),
        Teamocil::Command::SendKeysToPane.new(index: "#{name}.#{pane_base_index + 1}", keys: 'bar'),
        Teamocil::Command::SendKeysToPane.new(index: "#{name}.#{pane_base_index + 1}", keys: 'Enter'),
        Teamocil::Command::SelectPane.new(index: "#{name}.#{pane_base_index + 1}")
      ]
    end
  end

  context 'without panes' do
    let(:panes) { nil }

    it do
      expect(as_tmux).to eql [
        Teamocil::Command::NewWindow.new(name: name, root: root),
        Teamocil::Command::SelectPane.new(index: "#{name}.#{pane_base_index}")
      ]
    end
  end

  context 'with layout attribute' do
    let(:layout) { 'tiled' }

    it do
      expect(as_tmux).to eql [
        Teamocil::Command::NewWindow.new(name: name),
        Teamocil::Command::SendKeysToPane.new(index: "#{name}.#{pane_base_index}", keys: 'foo; omg'),
        Teamocil::Command::SendKeysToPane.new(index: "#{name}.#{pane_base_index}", keys: 'Enter'),
        Teamocil::Command::SelectLayout.new(layout: layout, name: name),
        Teamocil::Command::SplitWindow.new(name: name),
        Teamocil::Command::SendKeysToPane.new(index: "#{name}.#{pane_base_index + 1}", keys: 'bar'),
        Teamocil::Command::SendKeysToPane.new(index: "#{name}.#{pane_base_index + 1}", keys: 'Enter'),
        Teamocil::Command::SelectLayout.new(layout: layout, name: name),
        Teamocil::Command::SelectPane.new(index: "#{name}.#{pane_base_index + 1}")
      ]
    end
  end

  context 'with --here option' do
    context 'without root' do
      let(:options) { { here: true } }

      it do
        expect(as_tmux).to eql [
          Teamocil::Command::RenameWindow.new(name: name),
          Teamocil::Command::SendKeysToPane.new(index: "#{name}.#{pane_base_index}", keys: 'foo; omg'),
          Teamocil::Command::SendKeysToPane.new(index: "#{name}.#{pane_base_index}", keys: 'Enter'),
          Teamocil::Command::SplitWindow.new(name: name),
          Teamocil::Command::SendKeysToPane.new(index: "#{name}.#{pane_base_index + 1}", keys: 'bar'),
          Teamocil::Command::SendKeysToPane.new(index: "#{name}.#{pane_base_index + 1}", keys: 'Enter'),
          Teamocil::Command::SelectPane.new(index: "#{name}.#{pane_base_index + 1}")
        ]
      end
    end

    context 'with root' do
      let(:root) { '/tmp' }
      let(:options) { { here: true } }

      it do
        expect(as_tmux).to eql [
          Teamocil::Command::SendKeysToPane.new(index: "#{name}.#{pane_base_index}", keys: 'cd "/tmp"'),
          Teamocil::Command::SendKeysToPane.new(index: "#{name}.#{pane_base_index}", keys: 'Enter'),
          Teamocil::Command::RenameWindow.new(name: name),
          Teamocil::Command::SendKeysToPane.new(index: "#{name}.#{pane_base_index}", keys: 'foo; omg'),
          Teamocil::Command::SendKeysToPane.new(index: "#{name}.#{pane_base_index}", keys: 'Enter'),
          Teamocil::Command::SplitWindow.new(name: name, root: root),
          Teamocil::Command::SendKeysToPane.new(index: "#{name}.#{pane_base_index + 1}", keys: 'bar'),
          Teamocil::Command::SendKeysToPane.new(index: "#{name}.#{pane_base_index + 1}", keys: 'Enter'),
          Teamocil::Command::SelectPane.new(index: "#{name}.#{pane_base_index + 1}")
        ]
      end
    end
  end
end
