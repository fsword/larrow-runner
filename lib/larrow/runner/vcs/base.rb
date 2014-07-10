module Larrow
  module Runner
    module Vcs
      class Base
        def load_manifest
          Manifest.load_manifest self
        end

        def formatted_url
          raise 'not implement yet'
        end
      end
    end
  end
end
