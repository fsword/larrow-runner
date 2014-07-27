require 'larrow/qingcloud'
require 'larrow/runner/config'

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
          image_id = 'trustysrvx64a'
          instances = Qingcloud::Instance.create(image_id,'small_a',count:count, login_mode: 'keypair')

          eips = Qingcloud::Eip.create(count:count)
          instances.each{|x| x.wait_for :running}

          eips.each{|x| x.wait_for :available}
          
          (0...count).map do |i|
            instances[i].associate eips[i]
            [instances[i], eips[i]]
          end
        end
      end
    end
  end
end
