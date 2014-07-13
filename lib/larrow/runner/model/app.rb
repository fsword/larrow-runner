module Larrow
  module Runner
    module Model
      class App
        attr_accessor :vcs, :node, :configuration
        def initialize vcs
          self.vcs = vcs
          self.configuration = vcs.load_manifest
        end

        def assign arg
          arg.each_pair do |k,v|
            self.send "#{k}=".to_sym, v
          end
        end

        def action skip_test=false
          configuration.each_step(skip_test) do |a_step|
            node.execute a_step.scripts.map(&:actual_command) do |data|
              Logger.info "\t#{data}"
            end
            #fail script.actual_command if script.is_fail_ignored
          end
        end
      end
    end
  end
end
