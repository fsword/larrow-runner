require 'yaml'

module Larrow
  module Runner
    module Manifest
      class Travis < Base
        CONFIG_FILE='/.travis.yml'
        attr_accessor :data, :configuration
       
        def parse content
          self.data  = YAML.load(content).with_indifferent_access
          map_step :prepare,         :before_script
          map_step :functional_test, :script
          build_language
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
        TEMPLATE_PATH='/opt/install/erlang/%s/activate'
        def self.fulfill data, configuration
          revision = case data[:otp_release].max
                     when /R15/ then 'r15'
                     when /R16/ then 'r16'
                     when /17/  then 'r17'
                     else 'r17'
                     end rescue 'r17'
          activate_path = sprintf(TEMPLATE_PATH,revision)
          s = Script.new "echo 'source #{activate_path}' >> $HOME/.bashrc"
          configuration.put_to_step :init, s
        end
      end
    end
  end
end

