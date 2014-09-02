require 'larrow/qingcloud'
require 'larrow/runner/config'

module Larrow
  module Runner
    module Service
      class Cloud
        include Qingcloud
        def initialize
          access_id   = Config.qingcloud[:qy_access_key_id]
          secret_key  = Config.qingcloud[:qy_secret_access_key]
          zone_id     = Config.qingcloud[:zone_id] || 'pek1'
          @keypair_id = Config.qingcloud[:keypair_id]
          Qingcloud.establish_connection access_id,secret_key,zone_id
        end

        # return: Array< [ instance,eip ] >
        # WARN: eips contains promise object, so it should be force
        def create image_id:nil,count:1
          RunLogger.level(1).detail "assign node"
          instances = Instance.create(image_id: image_id,
                                                 count:count,
                                                 login_mode:'keypair',
                                                 keypair_id: @keypair_id
                                                )

          eips = Eip.create(count:count)
          
          (0...count).map do |i|
            RunLogger.level(1).detail "bind ip: #{eips[i].address}"
            eips[i] = eips[i].associate instances[i].id
            [ instances[i], eips[i] ]
          end
        end

        # return image future
        def create_image instance_id
          Image.create instance_id
        end

        def image? image_id
          Image.list(:self, ids: [image_id]).size == 1
        end
      end
    end
  end
end
