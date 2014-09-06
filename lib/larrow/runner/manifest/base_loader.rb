module Larrow::Runner::Manifest
  class BaseLoader
    attr_accessor :source_accessor,:configuration
    def initialize source_accessor
      self.source_accessor = source_accessor
    end

    def load
      content = source_accessor.get self.class.const_get 'CONFIG_FILE'
      return nil if content.nil?

      self.configuration = Configuration.new
      parse content
      self.configuration
    end
  end
end
