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

        def execute cmd, base_dir:nil, cannt_fail: true
          connection.open_channel do |ch|
            RunLogger.level(1).detail "# #{cmd}"
            cmd = "cd #{base_dir}; #{cmd}" unless base_dir.nil?
            ch.exec cmd do |ch,success|
              if RunOption.key? :debug
                ch.on_data do |c, data|
                  if block_given?
                    yield data
                  else
                    data.split(/\r?\n/).each do |msg|
                      RunLogger.level(1).info msg
                    end
                  end
                end
                ch.on_extended_data do |c, type, data|
                  if block_given?
                    yield data
                  else
                    data.split(/\r?\n/).each do |msg|
                      RunLogger.level(1).info msg
                    end
                  end
                end
              end
              ch.on_request('exit-status') do |c,data|
                status = data.read_long
                RunLogger.level(1).info "exit #{status}"
                fail ExecutionError,cmd if status != 0
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
