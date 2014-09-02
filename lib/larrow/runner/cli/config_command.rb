require 'yaml'
module Larrow::Runner::Cli
  class ConfigCommand < ::Thor
    include Larrow::Runner

    desc 'generate','generate default configuration'
    option :force, type: :boolean
    def generate
      Config.generate options[:force]
      show
    end

    desc 'show','show all configuration'
    def show
      puts YAML.dump Config.all.to_hash
    end
  end
end
