module Larrow::Runner::Model
  class Node
    include Larrow::Runner::Service
    attr_accessor :instance, :eip
    attr_accessor :user,:host
    def initialize instance, eip, user='root'
      self.instance = instance
      self.eip = eip
      self.host = eip.address
      self.user = user
      @executor = Executor.new host, user, nil, nil
    end

    def execute command, base_dir: nil
      @executor.execute command, base_dir: base_dir
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
