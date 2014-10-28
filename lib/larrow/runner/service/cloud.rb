require 'larrow/qingcloud'

module Larrow
  module Runner
    module Service
      class Cloud
        include Qingcloud
        def initialize args={}
          Qingcloud.remove_connection
          access_id   = args[:qy_access_key_id]
          secret_key  = args[:qy_secret_access_key]
          zone_id     = args[:zone_id]
          @keypair_id = args[:keypair_id]
          Qingcloud.establish_connection access_id,secret_key,zone_id
        end

        # return: Array< [ instance,eip ] >
        # WARN: eips contains promise object, so it should be force
        def create image_id:nil,count:1
          RunLogger.level(1).detail "assign node"
          instances = Instance.create(image_id: image_id||'trustysrvx64c',
                                      count:count,
                                      login_mode:'keypair',
                                      keypair_id: @keypair_id
                                     )

          eips = Eip.create(count:count)
          
          (0...count).map do |i|
            RunLogger.level(1).detail "bind ip: #{eips[i].address}"
            eips[i] = eips[i].associate instances[i].id
            [ instances[i], eips[i] ]
          end.tap do |list|
            list.each{|instance,eip| ping eip.address}
          end
        end

        # return image future
        def create_image instance_id
          Image.create instance_id
        end

        def image? image_id
          Image.list(:self, ids: [image_id]).size == 1
        end

        # concurrent destroy(force)
        def destroy *args
          args.map(&:destroy).map(&:force)
        end

        def check_available
          KeyPair.list
          self
        rescue
          Qingcloud.remove_connection
          raise $!
        end

        def ping addr, port=22
          10.times do
            return true if system("ping #{addr} -c 1 -W 2 2>&1 >/dev/null")
            RunLogger.level(1).detail "check available: #{addr}"
          end
          return false
        end
      end
    end
  end
end
