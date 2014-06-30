module Larrow
  module Runner
    module Vcs
      class Base
        def formatted_url
          raise 'not implement yet'
        end

        def load_manifests
          @manifests ||= begin
                           body = try_gets '.larrow.yml','.travis.yml'
                           parse body if body
                         end
        end

        def try_gets *files
        end

        def parse body
          #TODO
        end
      end
    end
  end
end
