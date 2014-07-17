module Larrow
  module Runner
    module Model
      class App
        attr_accessor :vcs, :node, :configuration
        def initialize vcs
          self.vcs = vcs
          self.configuration = vcs.load_configuration
        end

        def assign arg
          arg.each_pair do |k,v|
            self.send "#{k}=".to_sym, v
          end
        end

        def action skip_test=false
          configuration.each_step(skip_test) do |a_step|
            a_step.scripts.each do |script|
              node.execute(script.actual_command,
                           base_dir:script.base_dir
                          ) do |data|
                Logger.info "\t#{data}"
              end
            end
          end
        end
      end
    end
  end
end
