module Larrow
  module Runner
    module Vcs
      class Base
        def load_configuration
          Manifest.load_configuration(self)
        end

        def formatted_url
          raise 'not implement yet'
        end
      end
    end
  end
end
