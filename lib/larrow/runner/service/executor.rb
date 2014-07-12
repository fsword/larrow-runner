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
        end

        def execute *cmds, base_dir:nil
          Net::SSH.start(ip,user) do |session|
            session.open_channel do |chx|
              chx.exec("bash -l") do |ch, success|
                ch.on_data do |c, data|
                  yield data
                end
                ch.send_data "export TERM=vt100\n"
                cmds.each do |cmd|
                  ch.send_data "#{cmd}\n"
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
