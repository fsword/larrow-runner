require 'yaml'
module Larrow
  module Runner
    module Option
      extend self

      FILE = "#{ENV['HOME']}/.larrow"
      def generate force
        return if File.exist?(FILE) && !force
        puts "The larrow config will be generated at #{FILE}."
        qingcloud = {}
        [:qy_access_key_id,
         :qy_secret_access_key,
         :zone_id,
         :keypair_id
        ].each do |name|
          qingcloud[name.to_s] = request_var(name)
        end

        content={'qingcloud' => qingcloud}
        File.open(FILE, 'w+'){|f| f.write YAML.dump(content)}
      end

      def all
        @config ||= YAML.load_file(FILE).with_indifferent_access
      end

      def qingcloud
        all[:qingcloud]
      end

      def request_var name
        print "> Please input #{name}："
        $stdin.readline.chop
      end
    end
  end
end
