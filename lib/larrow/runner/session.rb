require 'yaml'
module Larrow
  module Runner
    module Session
      extend self

      FILE = "#{ENV['HOME']}/.larrow"
      def login
        return if File.exist?(FILE) && !can_overwrite
        puts "The larrow config will be generated at #{FILE}."
        data = nil
        loop do
          data = [:qy_access_key_id,
                  :qy_secret_access_key,
                  :zone_id,
                  :keypair_id].
                  reduce({}){|s,key| s.update key => value_for(key)}

          cloud = Service::Cloud.new data
          begin
            cloud.check_available
            RunLogger.info "login success! write to ~/.larrow"
            break
          rescue Exception => e
            RunLogger.info "login fail: #{e.message}"
            return unless ask "try again ? "
          end
        end
        content={'qingcloud' => data}
        File.write FILE, YAML.dump(content)
      end

      def load_cloud
        args = begin
                 YAML.
                   load(File.read FILE).
                   with_indifferent_access[:qingcloud]
               rescue
                 nil
               end
        Service::Cloud.new args if args
      end

      def value_for name
        print sprintf("%25s: ", name)
        v = $stdin.gets.strip
        v.empty? ? nil : v
      end

      def can_overwrite
        RunOption[:force] || ask("overwrite #{FILE} ? ")
      end

      def ask title
        print title
        v = $stdin.gets.strip
        ['Yes','Y','y','yes'].include? v
      end
    end
  end
end
