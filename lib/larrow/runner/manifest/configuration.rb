module Larrow
  module Runner
    module Manifest
      # Common model for different manifest style
      module Configuration
        # The top of manifest model which store Steps information 
        class Build
          DEFINED_STEPS = [:prepare, 
                          :compile, :unit_test, 
                          :install, :functional_test, 
                          :start, :integration_test]
          attr_accessor :steps
          def initialize
            self.steps = Hash[ DEFINED_STEPS.product([nil]) ]
          end
        end

        # Describe a set of scripts to accomplish a specific goal
        class Step
          attr_accessor :scripts, :is_test
          def initialize scripts, is_test
            self.scripts = scripts
            self.is_test = is_test
          end
        end

        # store the real command line
        #   :is_fail_ignored used to declare `non-zero retcode of current script can be ignored`
        class Script
          attr_accessor :cmd, :meta, :is_fail_ignored
          def initialize cmd, meta, is_fail_ignored=nil
            self.cmd = cmd
            self.meta = meta
            self.is_fail_ignored = is_fail_ignored
          end
        end
      end
    end
  end
end
