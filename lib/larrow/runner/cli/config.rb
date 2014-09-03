require 'yaml'
module Larrow::Runner::Cli
  class Config < ::Thor
    include Larrow::Runner

    desc 'generate','generate default configuration'
    option :force, type: :boolean
    def generate
      Option.generate options[:force]
      show
    end

    desc 'show','show all configuration'
    def show
      puts YAML.dump Option.all.to_hash
    end

    desc 'transfer [URL]','dump configuration of the project'
    def transfer url
      vcs = Vcs.detect url
      configuration = vcs.load_configuration
      puts configuration.dump
    end
  end
end
