require 'larrow/qingcloud'
require 'larrow/runner/config'

module Larrow
  module Runner
    module Service
      class Cloud
        def initialize
          access_id   = Config.qingcloud[:qy_access_key_id]
          secret_key  = Config.qingcloud[:qy_secret_access_key]
          zone_id     = Config.qingcloud[:zone_id] || 'pek1'
          @keypair_id = Config.qingcloud[:keypair_id]
          Qingcloud.establish_connection access_id,secret_key,zone_id
        end

        def create count=1,image_id:'trustysrvx64a'
          RunLogger.level(1).detail "assign node"
          instances = Qingcloud::Instance.create(image_id,
                                                 count:count,
                                                 login_mode:'keypair',
                                                 keypair_id: @keypair_id
                                                )

          eips = Qingcloud::Eip.create(count:count)
          
          count.times do |i|
            RunLogger.level(1).detail "bind ip: #{eips[i].address}"
            eips[i] = eips[i].associate instances[i].id
          end
          # eips contains promise object, so it should be force
          (0...count).map{ |i| [instances[i], eips[i]]}
        end

        # return image future
        def create_image instance_id
          Qingcloud::Image.create instance_id
        end

        def image? image_id
          Qingcloud::Image.list(:self, ids: [image_id]).size == 1
        end
      end
    end
  end
end
