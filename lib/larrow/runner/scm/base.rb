module Larrow
  module Runner
    module Scm
      class Base
        def gen_node
          # assign one node for project by default
          App.new formatted_url, self
        end

        def formatted_url
          raise 'not implement yet'
        end
      end
    end
  end
end
