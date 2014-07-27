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
          @connection = Net::SSH.start(ip,user)
          @canceling = nil
          if Option[:debug]
            @logger = Logger
          else
            @logger = ::Logger.new "#{ip}_cmd.log"
          end
        end

        def execute cmd, base_dir:nil, cannt_fail: true
          @connection.open_channel do |ch|
            if Option[:debug]
              info "\tcmd: #{cmd}"
            else
              Logger.info "\tcmd: #{cmd}"
            end
            cmd = "cd #{base_dir}; #{cmd}" unless base_dir.nil?
            ch.exec cmd do |ch,success|
              ch.on_data do |c, data|
                if block_given?
                  yield data
                else
                 info "\t\t #{data}"
                end
              end
              ch.on_extended_data do |c, type, data|
                if block_given?
                  yield data
                else
                 info "\t\t #{data}",:warn
                end
              end
              ch.on_request('exit-status') do |c,data|
                status = data.read_long
                info "\t\texit status: #{status}"
                fail ExecutionError,cmd if status != 0
              end
            end
          end
          trap("INT") { @canceling = true }
          @connection.loop(0.1) do
            not (@canceling || @connection.channels.empty?)
          end
        end

        def scp local_file_path, remote_file_path
          raise 'not completed.'
        end

        def info msg, decorator=:detail
          if Option[:debug]
            @logger.info msg.send decorator
          else
            @logger.info msg
          end
        end
      end
    end
  end
end
