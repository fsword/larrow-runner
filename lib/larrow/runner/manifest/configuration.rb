module Larrow
  module Runner
    module Manifest
      # The top of manifest model which store Steps information 
      class Configuration
        DEFINED_STEPS = [:init, #inner step
                         :source_sync, #inner step
                         :prepare, 
                         :compile, :unit_test,
                         :before_install, #inner_step
                         :install, :functional_test, 
                         :before_start, #inner_step
                         :start, :integration_test,
                         :after_start, :complete #inner_step
                        ]
        attr_accessor :steps
        def initialize
          self.steps = Hash[ DEFINED_STEPS.product([nil]) ]
        end

        def put_to_step title, *scripts
          steps[title] ||= Step.new(nil, title)
          steps[title].scripts += scripts.flatten
        end

        def each_step skip_test
          all_steps = if skip_test
                        DEFINED_STEPS.select{|x| x.to_s !~ /test/}
                      else
                        DEFINED_STEPS
                      end
          all_steps.each do |title|
            yield steps[title] if steps[title]
          end
        end
      end

      # Describe a set of scripts to accomplish a specific goal
      class Step
        attr_accessor :scripts, :title
        def initialize scripts, title
          self.scripts = scripts || []
          self.title = title
        end
      end

      # store the real command line
      #   :is_fail_ignored used to declare `non-zero retcode of current script can be ignored`
      class Script
        attr_accessor :cmd, :args, :is_fail_ignored
        def initialize cmd, args:{}, is_fail_ignored:nil
          self.cmd = cmd
          self.args = args
          self.is_fail_ignored = is_fail_ignored
        end

        def actual_command
          sprintf(cmd, args).tap do |command|
            Logger.info "actual: #{command} - #{cmd}: #{args}"
          end
        end
      end
    end
  end
end
