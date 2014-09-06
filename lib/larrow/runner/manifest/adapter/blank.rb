module Larrow::Runner::Manifest
  class Blank < BaseLoader
    def load
      self.configuration = Configuration.new
    end
  end
end

