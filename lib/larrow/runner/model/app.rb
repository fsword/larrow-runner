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
          Manifest::Configuration::DEFINED_STEPS.each do |step_name|
            do_step(configuration.steps, step_name)
          end

          node.prepare
          node.test unless skip_test
        end

        def do_step steps, name
          return if steps[name].nil?
          puts "\t\t[#{name}]"
          steps[name].scripts.map(&:cmd).each do |cmd|
            puts "\t\t#{cmd}"
          end
        end
      end
    end
  end
end
