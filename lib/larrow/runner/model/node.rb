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

    def execute command, base_dir:nil
      block = if block_given?
                -> (data) { yield data }
              else
                -> (data) {
                  data.split(/\r?\n/).each do |msg|
                    RunLogger.level(1).info msg 
                  end
                }
              end
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
