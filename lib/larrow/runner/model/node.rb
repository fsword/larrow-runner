module Larrow::Runner::Model
  class Node
    attr_accessor :instance, :eip
    attr_accessor :user,:host
    def initialize instance, eip, user='root'
      self.instance = instance
      self.eip = eip
      self.host = eip.address
      self.user = user
      @executor = Service::Executor.new host, user, nil, nil
    end

    def execute script, &block
      command = script.actual_command
      base_dir = script.base_dir
      @executor.execute command, base_dir: base_dir, &block
    end

    def stop
      self.instance = instance.stop
    end

    def destroy
      instance.destroy.force
      eip.destroy.force
      self
    end
  end
end
