module Larrow
  module Runner
    module Model
      class App
        attr_accessor :source_url, :node
        def initialize source_url
          self.source_url = source_url
        end

        def assign arg
          arg.each_pair do |k,v|
            self.send "#{k}=".to_sym, v
          end
        end

        def prepare
        end

        def action
        end

      end
    end
  end
end
