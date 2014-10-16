module Larrow::Runner::Manifest
  class BaseLoader
    attr_accessor :source_accessor,:configuration
    def initialize source_accessor
      self.source_accessor = source_accessor
    end

    def load
      content = source_accessor.get config_file
      return nil if content.nil?

      self.configuration = Configuration.new
      parse content
      self.configuration
    end
    
    def config_file
      self.class.const_get('CONFIG_FILE')
    end
  end
end
