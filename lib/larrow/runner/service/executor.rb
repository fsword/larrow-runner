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
          @session = Net::SSH.start(ip,user)
        end

        def execute cmd, base_dir:nil, cannt_fail: true, &output_callback
          @session.open_channel do |ch|
            Logger.info "call command(ch:#{ch.object_id}): #{cmd}"
            cmd = "cd #{base_dir}; #{cmd}" unless base_dir.nil?
            ch.exec cmd do |ch,success|
              ch.on_data do |c, data|
                if block_given?
                  yield data
                else
                  Logger.info "get stdout(ch:#{ch.object_id}): #{data}"
                end
              end
              ch.on_extended_data do |c, type, data|
                if block_given?
                  yield data
                else
                  Logger.info "get stderr(ch:#{ch.object_id},#{type}): #{data}"
                end
              end
              ch.on_request('exit-status') do |c,data|
                status = data.read_long
                Logger.info "exit status(ch:#{ch.object_id}): #{status}"
                fail ExecutionError,cmd if status != 0
              end
            end
          end.wait
        end

        def scp local_file_path, remote_file_path
          raise 'not completed.'
        end
      end
    end
  end
end
