module Larrow::Runner::Manifest
  class Larrow < BaseLoader
    CONFIG_FILE='/.larrow.yml'

    # TODO manifest validation
    def parse content
      YAML.load(content).with_indifferent_access
    end
  end
end

