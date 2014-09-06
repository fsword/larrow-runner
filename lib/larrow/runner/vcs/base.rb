module Larrow::Runner::Vcs
  class Base
    include Larrow::Runner
    def configuration merge=true
      configuration = Manifest.configuration(self)
      if merge
        Manifest.add_base_scripts configuration,self
      else
        configuration
      end
    end

    def formatted_url
      raise 'not implement yet'
    end
  end
end
