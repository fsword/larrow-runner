require 'larrow/qingcloud'
require 'larrow/runner/config'

module Larrow
  module Runner
    module Service
      class Vm
        def initialize
          access_id  = Config.vm[:qy_access_key_id]
          secret_key = Config.vm[:qy_secret_access_key]
          zone_id    = Config.vm[:zone_id] || 'pek1'
          Qingcloud.establish_connection access_id,secret_key,zone_id
        end

        def create count=1
          image_id = 'trustysrvx64a'
          RunLogger.level(1).detail "create VM nodes"
          instances = Qingcloud::Instance.create(image_id,
                                                 count:count,
                                                 login_mode:'keypair',
                                                 keypair_id: 'kp-t82jrcvw'
                                                )

          RunLogger.level(1).detail "ask for IPs"
          eips = Qingcloud::Eip.create(count:count)
          
          count.times do |i|
            RunLogger.level(1).detail "bind ip: #{eips[i].address}"
            eips[i] = eips[i].associate instances[i].id
          end
          # eips contains promise object, so it should be force
          (0...count).map{ |i| [instances[i], eips[i].force]}
        end
      end
    end
  end
end
