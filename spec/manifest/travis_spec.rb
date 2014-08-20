require_relative '../spec_helper.rb'

module Larrow::Runner::Manifest
  describe Travis do
    class FileLoad
      attr_accessor :filename
      def initialize filename
        self.filename = filename
      end

      def get _filename
        path = File.expand_path "../../fixtures/#{filename}", __FILE__
        File.read(path)
      end

      def source_sync_script; '' end
    end

    subject do
      Travis.new(FileLoad.new 'travis.yml').load
    end

    it 'parse the manifest file' do
      expect(subject.steps[:prepare].scripts.size).to eq(5)
      step = subject.steps[:functional_test]
      expect(step.scripts.size).to eq(1)
      expect(step.scripts.first.cmd).to eq('./rebar compile ct')
    end

    it 'support erlang' do
      scripts = subject.steps[:init].scripts
      commands = scripts.map(&:actual_command).join("\n")
      expect(commands).to include('activate')
      expect(commands).to include('r16')
    end
  end
end