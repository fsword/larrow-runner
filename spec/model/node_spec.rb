require_relative '../spec_helper.rb'

module Larrow::Runner::Model
  describe Node do
    subject{ Node.new nil, OpenStruct.new(address: 'localhost'), `whoami`.chomp }
    before do 
      Larrow::Runner::RunOption[:debug] = nil
    end
    it 'can execute' do
      outputs = ""
      script = OpenStruct.new(actual_command: 'pwd')
      subject.execute('pwd') do |data|
        outputs << data
      end
      expect(outputs).to include(ENV['HOME'])
    end
  end
end
