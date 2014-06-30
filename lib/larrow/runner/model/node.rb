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
        end

        def prepare
        end

        def test
        end
      end
    end
  end
end
