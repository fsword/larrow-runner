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
    end

    before do
      @travis_mock = FileLoad.new 'travis.yml'
    end

    subject{ Travis.new @travis_mock }
    it 'parse the manifest file' do
      build = subject.load_manifest
      expect(build.steps[:prepare].scripts.size).to eq(5)

      step = build.steps[:functional_test]
      expect(step.scripts.size).to eq(1)
      expect(step.scripts.first.cmd).to eq('./rebar compile ct')
    end
  end
end
