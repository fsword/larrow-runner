require_relative '../../spec_helper.rb'

module Larrow::Runner::Manifest
  describe Travis do
    class FileLoad
      attr_accessor :filename
      def initialize filename
        self.filename = filename
      end

      def get _filename
        path = File.expand_path "../../../fixtures/#{filename}", __FILE__
        File.read(path)
      end

      def source_sync_script; '' end
    end

    let(:erlang_conf){ Travis.new(FileLoad.new 'travis_erlang.yml').load }
    let(:ruby_conf){ Travis.new(FileLoad.new 'travis_ruby.yml').load }

    it 'parse the manifest file' do
      expect(erlang_conf.steps[:prepare].scripts.size).to eq(1)
      step = erlang_conf.steps[:functional_test]
      expect(step.scripts.size).to eq(1)
      expect(step.scripts.first.cmd).to eq('./rebar compile ct')
    end

    it 'support erlang by kerl' do
      scripts = erlang_conf.steps[:init].scripts
      commands = scripts.map(&:actual_command).join("\n")
      expect(commands).to include('activate')
      expect(commands).to include('r16')
    end
    
    it 'support ruby by rvm' do
      scripts = ruby_conf.steps[:init].scripts
      commands = scripts.map(&:actual_command).join("\n")
      expect(commands).to include('rvm.io')
    end
  end
end
