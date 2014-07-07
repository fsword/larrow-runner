require 'yaml'

module Larrow
  module Runner
    module Manifest
      class Travis < Base
        CONFIG_FILE='/.travis.yml'
        attr_accessor :data, :build
       
        def parse content
          self.data  = YAML.load(content).with_indifferent_access
          self.build = Build.new
          map_step :prepare,         :before_script
          map_step :functional_test, :script
          self.build
        end
       
        def map_step larrow_step, travis_step
          scripts = (data[travis_step] || []).map do |cmd|
            Script.new cmd, {}
          end
          return nil if scripts.empty?

          is_test = larrow_step.to_s.end_with?('_test')
          build.steps[larrow_step] = Step.new(scripts, is_test)
        end
      end
    end
  end
end

