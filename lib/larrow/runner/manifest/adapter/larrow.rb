module Larrow
  module Runner
    module Manifest
      class Larrow < Base
        CONFIG_FILE='/.larrow.yml'

        # TODO manifest validation
        def parse content
          YAML.load(content).with_indifferent_access
        end
      end
    end
  end
end

