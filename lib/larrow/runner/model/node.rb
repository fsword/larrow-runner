module Larrow
  module Runner
    module Model
      class Node
        attr_accessor :instance, :eip
        attr_accessor :user,:host
        def initialize instance, eip
          self.instance = instance
          self.eip = eip
          self.host = eip.address
          self.user = user || 'root'
          @executor = Service::Executor.new host, user, nil, nil
        end

        def execute *commands
          @executor.execute *commands.flatten
        end

        def destroy
          instance.destroy
          eip.destroy
          self
        end
      end
    end
  end
end
