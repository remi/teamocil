require 'spec_helper'

RSpec.describe Teamocil::CLI do
  describe :run! do
    let(:cli) { Teamocil::CLI.new(arguments: arguments, environment: environment) }
    let(:environment) { { 'HOME' => Dir.tmpdir } }
    let(:root) { File.join(environment['HOME'], '.teamocil') }

    describe 'with --list option' do
      let(:arguments) { ['--list'] }

      before do
        expect(Teamocil::Layout).to receive(:print_available_layouts).with(directory: root)
      end

      specify { cli.run! }
    end

    describe 'with --show option' do
      let(:arguments) { ['--show', 'foo'] }
      let(:layout) { double(Teamocil::Layout) }
      let(:path) { File.join(root, 'foo.yml') }

      before do
        expect(Teamocil::Layout).to receive(:new).with(path: path).and_return(layout)
        expect(layout).to receive(:show!)
      end

      specify { cli.run! }
    end

    describe 'with --edit option' do
      let(:arguments) { ['--edit', 'foo'] }
      let(:layout) { double(Teamocil::Layout) }
      let(:path) { File.join(root, 'foo.yml') }

      before do
        expect(Teamocil::Layout).to receive(:new).with(path: path).and_return(layout)
        expect(layout).to receive(:edit!)
      end

      specify { cli.run! }
    end

    describe 'with implicit execution' do
      context 'with --layout option' do
        let(:arguments) { ['--layout', path] }
        let(:layout) { double(Teamocil::Layout) }
        let(:path) { File.join(root, 'bar.yml') }

        before do
          expect(Teamocil::Layout).to receive(:new).with(path: path).and_return(layout)
          expect(layout).to receive(:execute!)
        end

        specify { cli.run! }
      end

      context 'without --layout option' do
        let(:arguments) { ['foo'] }
        let(:layout) { double(Teamocil::Layout) }
        let(:path) { File.join(root, 'foo.yml') }

        before do
          expect(Teamocil::Layout).to receive(:new).with(path: path).and_return(layout)
          expect(layout).to receive(:execute!)
        end

        specify { cli.run! }
      end
    end
  end
end
