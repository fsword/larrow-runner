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
            Logger.info "#{a_step.title}: begin"
            begin_at = Time.new
            a_step.scripts.each do |script|
              node.execute(script.actual_command,
                           base_dir:script.base_dir
                          ) do |data|
                Logger.info "\t#{data}"
              end
            end
            during = sprintf('%.2f',Time.new - begin_at)
            Logger.info "#{a_step.title}: end (#{during}s)"
          end
        end
      end
    end
  end
end
