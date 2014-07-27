require_relative '../spec_helper.rb'
require 'ostruct'

module Larrow::Runner::Model
  describe Node do
    subject{ Node.new nil, OpenStruct.new(address: 'localhost'), `whoami`.chomp }
    it 'can execute' do
      outputs = ""
      script = OpenStruct.new(actual_command: 'pwd')
      subject.execute(script) do |data|
        outputs << data
      end
      expect(outputs).to include('home')
    end
  end
end
