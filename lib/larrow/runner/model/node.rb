module Larrow
  module Runner
    module Model
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

        def execute command, base_dir: nil
          @executor.execute command, base_dir: base_dir do |data|
            yield data
          end
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
