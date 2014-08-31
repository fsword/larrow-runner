require 'yaml'

module Larrow
  module Runner
    module Manifest
      class Travis < Base
        CONFIG_FILE='/.travis.yml'
        attr_accessor :data, :configuration
       
        def parse content
          self.data  = YAML.load(content).with_indifferent_access
          build_language
          map_step :prepare,         :before_script
          map_step :functional_test, :script
          configuration
        end
       
        def map_step title, travis_title
          scripts = (data[travis_title] || []).map do |cmd|
            Script.new cmd, base_dir: '$HOME/source'
          end
          return nil if scripts.empty?

          configuration.put_to_step title, scripts
        end

        def build_language
          return if data[:language].nil?
          clazz = eval data[:language].camelize
          clazz.fulfill(data,configuration)
        end
      end
      class Erlang
        TEMPLATE_PATH='/opt/install/erlang/%s'
        def self.fulfill data, configuration
          revision = case data[:otp_release].last
                       when /R15/ then 'R15B03-1'
                       when /R16/ then 'R16B03-1'
                       when /17/  then '17.1'
                     end rescue '17'
          install_dir = sprintf(TEMPLATE_PATH,revision.downcase)
          lines = <<-EOF
apt-get update -qq
apt-get install git libssl-dev build-essential curl libncurses5-dev -y -qq
echo '-s' >> .curlrc
curl https://raw.githubusercontent.com/spawngrid/kerl/master/kerl -o /usr/local/bin/kerl
chmod a+x /usr/local/bin/kerl
kerl update releases
kerl build #{revision} #{revision}
kerl install #{revision} #{install_dir}
echo 'source #{install_dir}/activate' >> $HOME/.bashrc
          EOF
          lines.split(/\n/).each do |line|
            s = Script.new line
            configuration.put_to_step :init, s
          end
        end
      end
    end
  end
end

