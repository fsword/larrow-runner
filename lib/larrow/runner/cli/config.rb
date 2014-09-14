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

  end
end
