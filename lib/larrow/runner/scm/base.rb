module Larrow
  module Runner
    module Scm
      class Base
        def gen_node
          Node.new checkout_url
        end
      end
    end
  end
end
