require_relative '../spec_helper.rb'
module Larrow::Runner::Service
  describe Executor do
    subject{ Executor.new 'localhost', `whoami`.chomp, 22, nil }
    it 'long time commands run'do
      outputs = ''
      subject.execute(
        ['echo aaa',
        'echo bbb',
        'sleep 1',
        'echo ccc',
        'sleep 1'].join(' && ')
      ){|data| outputs << data}
      expect(outputs).to eq "aaa\nbbb\nccc\n"
    end

    it 'command sequence' do
      outputs = ''
      subject.execute(
        ['cd $HOME/..',
        'ls -l'].join(' && ')
      ){|data| outputs << data}
      expect(outputs).to include(`whoami`)
    end

    it 'fail command' do
      expect(->{subject.execute('false')}).to raise_error(ExecutionError)
    end
  end
end
