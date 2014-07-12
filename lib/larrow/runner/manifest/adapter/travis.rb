require 'yaml'

module Larrow
  module Runner
    module Manifest
      class Travis < Base
        CONFIG_FILE='/.travis.yml'
        attr_accessor :data, :configuration
       
        def parse content
          self.data  = YAML.load(content).with_indifferent_access
          self.configuration = Configuration.new
          map_step :prepare,         :before_script
          map_step :functional_test, :script
          self.configuration
        end
       
        def map_step title, travis_title
          scripts = (data[travis_title] || []).map do |cmd|
            Script.new cmd, {}
          end
          return nil if scripts.empty?

          configuration.steps[title] = Step.new(scripts, title)
        end
      end
    end
  end
end

