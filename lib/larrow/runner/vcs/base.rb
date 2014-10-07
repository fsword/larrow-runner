module Larrow::Runner::Vcs
  class Base
    include Larrow::Runner
    def configuration
      configuration = Manifest.configuration(self)
      unless configuration.image
        Manifest.add_base_scripts configuration,self
      end
      configuration
    end

    def formatted_url
      raise 'not implement yet'
    end
  end
end
