require 'net/ssh'
require 'net/scp'

module Larrow
  module Runner
    module Service
      class Executor
        attr_accessor :ip, :user, :port, :password
        def initialize ip, user, port, password
          self.ip       = ip
          self.user     = user
          self.port     = port
          self.password = password
          @canceling = nil
          @dlogger = RunLogger #::Logger.new "#{ip}_cmd.log"
        end

        def execute cmd, base_dir:nil
          connection.open_channel do |ch|
            RunLogger.level(1).detail "# #{cmd}"
            cmd = "cd #{base_dir}; #{cmd}" unless base_dir.nil?
            errmsg = ''
            ch.exec cmd do |ch,success|
              if RunOption.key? :debug
                ch.on_data{ |c, data| yield data }
                ch.on_extended_data{ |c, type, data| yield data }
              else
                ch.on_extended_data{ |c, type, data| errmsg << data }
              end
              ch.on_request('exit-status') do |c,data|
                status = data.read_long
                if status != 0
                  fail ExecutionError,{cmd:cmd,
                                       errmsg: errmsg, 
                                       status: status}
                end
              end
            end
          end
          trap("INT") { @canceling = true }
          connection.loop(0.1) do
            not (@canceling || connection.channels.empty?)
          end
        end

        def scp local_file_path, remote_file_path
          raise 'not completed.'
        end

        def connection
          @connection ||= Net::SSH.start(ip,user)
        end
      end
    end
  end
end
