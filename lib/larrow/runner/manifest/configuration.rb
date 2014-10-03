module Larrow::Runner::Manifest
  # The top of manifest model which store Steps information 
  class Configuration
    DEFINED_GROUPS = {
      all:[
        :init,
        :source_sync, #inner step
        :prepare, 
        :compile, :unit_test,
        :before_install, #inner_step
        :install, :functional_test, 
        :before_start, #inner_step
        :start, :integration_test,
        :after_start, :complete #inner_step
      ],
      custom: [
        :init,
        :prepare, 
        :compile, :unit_test,
        :install, :functional_test, 
        :start, :integration_test,
      ],
      deploy: [
        :init,:source_sync,:prepare, 
        :compile,:before_install,:install,
        :before_start,:start,:after_start,
        :complete
      ],
      image: [:init]
    }
   
    attr_accessor :steps, :image, :source_dir
    def initialize
      self.steps = {}
      self.source_dir = '$HOME/source'
    end

    def put_to_step title, *scripts
      steps[title] ||= CmdStep.new(nil, title)
      steps[title].scripts += scripts.flatten
      self
    end

    def insert_to_step title, *scripts
      steps[title] ||= CmdStep.new(nil, title)
      steps[title].scripts.unshift *scripts.flatten
      self
    end

    def add_source_sync source_accessor
      steps[:source_sync] = FunctionStep.new do |node|
        source_accessor.update_source node,source_dir
      end
    end

    def steps_for type
      groups = DEFINED_GROUPS[type]
      # ignore init when image id is specified
      groups = groups - [:init] if image
      groups.each do |title|
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
  class CmdStep
    attr_accessor :scripts, :title
    def initialize scripts, title
      self.scripts = scripts || []
      self.title = title
    end

    def run_on node
      scripts.each do |script|
        node.execute script.actual_command, base_dir: script.base_dir
      end
    end
  end

  # An abstract step which bind business logic with block
  # This class designed for some typically service,eg:
  #   * local file folder sync
  #   * some service invoke
  class FunctionStep
    attr_accessor :block
    def initialize &block
      self.block = block
    end
    
    def run_on node
      block.call node
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
