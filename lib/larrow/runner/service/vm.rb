module Larrow
  module Runner
    module Service
      class Vm
        def initialize
          access_id = Config.all[:vm][:access_id]
          secret_key = Config.all[:vm][:secret_key]
          Qingcloud.establish_connection access_id,secret_key
        end

        def gen count: 1
          instance = Qingcloud::Instance.create(nil,nil,nil).first
          eip = Qingcloud::Eip.create(count:1).first
          instance.associate eip
          [{
            user: root,
            host: eip.address
          }]
        end
      end
    end
  end
end
