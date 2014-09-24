module Larrow::Runner::Manifest
  class Larrow < BaseLoader
    CONFIG_FILE='/.larrow.yml'

    # TODO manifest validation
    def parse content
      data = YAML.load(content).with_indifferent_access
      if data.is_a? Array # stages as a Array
        # TODO
      elsif data.is_a? Hash # steps as a Hash
        configuration.image = data[:image]
        Configuration::DEFINED_GROUPS[:custom].each do |title|
          v = data[title]
          build_step title,v if v
        end
      end
    end

    def build_step title, lines
      scripts = lines.map{|s| Script.new s}
      configuration.put_to_step title, scripts
    end
  end
end

