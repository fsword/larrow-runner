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
          RunLogger.level(1).detail "create VM nodes"
          instances = Qingcloud::Instance.create(image_id,'small_a',count:count, login_mode: 'keypair')

          RunLogger.level(1).detail "ask for IPs"
          eips = Qingcloud::Eip.create(count:count)
          instances.each{|x| x.wait_for :running}

          eips.each{|x| x.wait_for :available}
          
          (0...count).map do |i|
            RunLogger.level(1).detail "bind ip: #{eips[i].address}"
            instances[i].associate eips[i]
            [instances[i], eips[i]]
          end
        end
      end
    end
  end
end
