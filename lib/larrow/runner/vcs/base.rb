module Larrow::Runner::Vcs
  class Base
    attr_accessor :larrow_file
    include Larrow::Runner
    def configuration merge=true
      configuration = Manifest.configuration(self)
      if merge
        Manifest.add_base_scripts configuration,self
      end
      configuration
    end

    def formatted_url
      raise 'not implement yet'
    end
  end
end
