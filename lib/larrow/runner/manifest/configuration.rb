module Larrow::Runner::Manifest
  # The top of manifest model which store Steps information 
  class Configuration
    DEFINED_GROUPS = {
      all:[
        :init, #inner step
        :source_sync, #inner step
        :prepare, 
        :compile, :unit_test,
        :before_install, #inner_step
        :install, :functional_test, 
        :before_start, #inner_step
        :start, :integration_test,
        :after_start, :complete #inner_step
      ],
      deploy: [
        :init,:source_sync,:prepare, 
        :compile,:before_install,:install,
        :before_start,:start,:after_start,
        :complete
      ],
      image: [:init]
    }
   
    attr_accessor :steps
    def initialize
      self.steps = {}
    end

    def put_to_step title, *scripts
      steps[title] ||= Step.new(nil, title)
      steps[title].scripts += scripts.flatten
      self
    end

    def insert_to_step title, *scripts
      steps[title] ||= Step.new(nil, title)
      steps[title].scripts.unshift *scripts.flatten
      self
    end

    def steps_for type
      DEFINED_GROUPS[type].each do |title|
        yield steps[title] if steps[title]
      end
    end

    def dump
      data = DEFINED_GROUPS[:all].reduce({}) do |sum,title|
        next sum if steps[title].nil?
        scripts_data = steps[title].scripts.map(&:dump).compact
        sum.update title.to_s => scripts_data
      end
      YAML.dump data
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
  #   :cannt_fail used to declare `non-zero retcode of current script will be fail`
  class Script
    attr_accessor :cmd, :base_dir, :args, :cannt_fail
    def initialize cmd, base_dir:nil, args:{}, cannt_fail: true
      self.cmd = cmd
      self.args = args
      self.cannt_fail = cannt_fail
      self.base_dir = base_dir
    end

    def actual_command
      sprintf(cmd, args)
    end

    def dump
      return nil if cmd.empty?
      cmd
    end
  end
end
