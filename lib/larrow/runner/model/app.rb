module Larrow
  module Runner
    module Model
      class App
        attr_accessor :vcs, :node
        def initialize vcs
          self.vcs = vcs
        end

        def assign arg
          arg.each_pair do |k,v|
            self.send "#{k}=".to_sym, v
          end
        end

        def action skip_test=false
          node.prepare
          node.test unless skip_test
        end

      end
    end
  end
end
