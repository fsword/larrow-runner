module Larrow
  module Runner
    module Model
      class App
        attr_accessor :source_url, :scm, :node
        def initialize source_url, scm
          self.source_url = source_url
          self.scm = scm
        end

        def assign arg
          arg.each_pair do |k,v|
            self.send "#{k}=".to_sym, v
          end
        end

        def checkout
        end

        def prepare
        end

        def default_action
        end

      end
    end
  end
end
