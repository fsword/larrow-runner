module Larrow::Runner
  module Model
  class Node
    include Larrow::Runner::Service
    include Larrow::Qingcloud
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

    def resource
      {instance:{id: instance.id},
       eip:{id:eip.id, address:eip.address}
      }
    end

    def self.cleanup resources
      resources.map do |hash|
        instance = Instance.new hash[:instance][:id]
        [instance.destroy, hash]
      end.map do |future, hash|
        future.force
        [Eip.new(hash[:eip][:id]).destroy,hash]
      end.map do |future, hash|
        if future.force == :already_deleted
          RunLogger.detail "node has been cleaned"
        else
          RunLogger.detail "node cleaned: #{hash[:eip][:address]}"
        end
      end
    end

  end
  end
end
