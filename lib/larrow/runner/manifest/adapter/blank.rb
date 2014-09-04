module Larrow::Runner::Manifest
  class Blank < Base
    def load
      self.configuration = Configuration.new
      add_base_scripts
      configuration
    end
  end
end

