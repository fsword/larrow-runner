require 'yaml'
module Larrow
  module Runner
    module Config
      FILE = "#{ENV['HOME']}/.larrow"
      def self.generate
        return if File.exist? FILE 
        puts "The larrow config will be generated at #{FILE}."
        content={
          qingcloud: { qy_access_key_id: nil,
                       qy_secret_access_key: nil,
                       zone_id: nil,
                       keypair_id: nil}
        }
        File.open(FILE, 'w+'){|f| f.write YAML.dump(content)}
      end

      def self.all
        @config ||= YAML.load_file(FILE).with_indifferent_access
      end

      def self.qingcloud
        all[:qingcloud]
      end
    end
  end
end
