module Larrow
  module Runner
    module Vcs
      class Base
        def gen
          # assign one node for project by default
          Model::App.new formatted_url, self
        end

        def formatted_url
          raise 'not implement yet'
        end
      end
    end
  end
end
