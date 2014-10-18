require 'larrow/qingcloud'
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
      Session.cloud.destroy instance,eip
      self
    end

    def dump
      {
        instance:{id: instance.id},
        eip:{id:eip.id, address:eip.address}
      }
    end

    def self.show resources, level=0
      resources.map do |hash|
        node = load_obj hash
        RunLogger.level(level).detail "instance: #{node.instance.id}"
        RunLogger.level(level).detail "eip:"
        RunLogger.level(level+1).detail "id: #{node.eip.id}"
        RunLogger.level(level+1).detail "address: #{node.eip.address}"
      end
    end

    def self.cleanup resources
      resources.map do |hash|
        node = load_obj hash
        future{node.destroy}
      end.map do |node|
        RunLogger.info "node cleaned: #{node.eip.address}"
      end
    end

    def self.load_obj data
        instance = Instance.new data[:instance][:id]
        eip = Eip.new data[:eip][:id],address:data[:eip][:address]
        new instance,eip
    end

  end
  end
end
