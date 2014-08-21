require 'spec_helper'

RSpec.describe Teamocil::Layout do
  describe :execute! do
    let(:layout) { Teamocil::Layout.new(path: path) }
    let(:execute!) { layout.execute! }
    let(:path) { double('Path') }

    let(:options) { {} }
    before { allow(Teamocil).to receive(:options).and_return(options) }

    context 'without errors' do
      let(:raw_content) { double('Raw content') }
      let(:parsed_content) { double('Parsed content') }
      let(:session) { instance_double(Teamocil::Tmux::Session) }
      let(:commands) { ['foo', %w(bar omg)] }

      before do
        allow(Teamocil::Tmux::Session).to receive(:new).and_return(session)

        expect(File).to receive(:read).with(path).and_return(raw_content)
        expect(YAML).to receive(:load).with(raw_content).and_return(parsed_content)

        expect(session).to receive(:as_tmux).and_return(commands)
      end

      context 'without --debug option' do
        before do
          expect(Teamocil).to receive(:system).with('tmux foo; tmux bar; tmux omg')
        end

        specify { layout.execute! }
      end

      context 'with --debug option' do
        let(:options) { { debug: true } }

        before do
          expect(Teamocil).to receive(:puts).with("tmux foo\ntmux bar\ntmux omg")
        end

        specify { execute! }
      end
    end

    context 'with not-found layout' do
      before do
        # Let’s simulate an error from `File.read`
        expect(File).to receive(:read).with(path) { raise Errno::ENOENT }
      end

      it { expect { execute! }.to raise_error(Teamocil::Error::LayoutNotFound) }
    end

    context 'with invalid YAML layout' do
      let(:raw_content) { double('Raw content') }

      before do
        expect(File).to receive(:read).with(path).and_return(raw_content)

        # Let’s simulate an error from `YAML.load`
        expect(YAML).to receive(:load).with(raw_content) { raise Psych::SyntaxError.new(nil, 0, 0, 0, nil, nil) }
      end

      it { expect { execute! }.to raise_error(Teamocil::Error::InvalidYAMLLayout) }
    end
  end

  describe :show! do
    let(:layout) { Teamocil::Layout.new(path: path) }
    let(:show!) { layout.show! }
    let(:path) { double('Path') }
    let(:raw_content) { double('Raw content') }

    context 'with found layout' do
      before do
        expect(File).to receive(:read).with(path).and_return(raw_content)
        expect(Teamocil).to receive(:puts).with(raw_content)
      end

      specify { show! }
    end

    context 'with not-found layout' do
      before do
        # Let’s simulate an error from `File.read`
        expect(File).to receive(:read).with(path) { raise Errno::ENOENT }
      end

      it { expect { show! }.to raise_error(Teamocil::Error::LayoutNotFound) }
    end
  end

  describe :edit! do
    let(:layout) { Teamocil::Layout.new(path: path) }
    let(:edit!) { layout.edit! }
    let(:path) { double('Path') }

    before do
      expect(Teamocil).to receive(:system).with("$EDITOR #{path}")
    end

    specify { edit! }
  end

  describe :ClassMethods do
    describe :print_available_layouts do
      let(:tmpdir) { Dir.mktmpdir }
      let(:directory) { File.join(tmpdir, '.teamocil') }
      after { FileUtils.remove_entry(tmpdir) }

      before do
        FileUtils.mkdir_p(directory)
        FileUtils.touch(File.join(directory, 'foo.yml'))
        FileUtils.touch(File.join(directory, 'bar.yml'))
        FileUtils.touch(File.join(directory, 'omg.txt'))

        expect(Teamocil).to receive(:puts).with(%w(bar foo))
      end

      specify do
        Teamocil::Layout.print_available_layouts(directory: directory)
      end
    end
  end
end
