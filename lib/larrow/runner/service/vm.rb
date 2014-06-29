require 'larrow/qingcloud'
require 'larrow/runner/config'
require 'larrow/runner/model/node'

module Larrow
  module Runner
    module Service
      class Vm
        def initialize
          access_id = Config.vm[:qy_access_key_id]
          secret_key = Config.vm[:qy_secret_access_key]
          Qingcloud.establish_connection access_id,secret_key
        end

        def create count=1
          instances = Qingcloud::Instance.create('trustysrvx64a','small_a',count:count)
          eips = Qingcloud::Eip.create(count:count)

          instances.each{|x| x.wait_for :running}
          eips.each{|x| x.wait_for :available}
          
          (0...count).map do |i|
            instances[i].associate eips[i]
            Model::Node.new instances[i], eips[i]
          end
        end

        def destroy *nodes
          nodes.map do |node|
            node.instance.dissociate node.eip
            node.instance.destroy
            node.eip.destroy
          end
        end
      end
    end
  end
end
