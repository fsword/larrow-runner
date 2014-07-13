require 'net/ssh'
require 'net/scp'

module Larrow
  module Runner
    module Service
      class Executor
        attr_accessor :ip, :user, :port, :password
        attr_accessor :channelx, :channel
        def initialize ip, user, port, password
          self.ip       = ip
          self.user     = user
          self.port     = port
          self.password = password
        end

        def execute *cmds, base_dir:nil, ignore_fail: false
          cmds = cmds.flatten
          Net::SSH.start(ip,user) do |session|
            session.open_channel do |chx|
              chx.exec("bash -l") do |ch, success|
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
                  fail ExecutionError, cmds.join("\n") if status != 0
                end
                
                ch.send_data "export TERM=vt100\n"
                cmds.each do |cmd|
                  ch.send_data "#{cmd}\n"
                  Logger.info "call command(ch:#{ch.object_id}): #{cmd}"
                end
                ch.send_data "exit\n"
              end
            end.wait
          end
        end

        def scp local_file_path, remote_file_path
          raise 'not completed.'
        end
      end
    end
  end
end
