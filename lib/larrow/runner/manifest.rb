require 'larrow/runner/manifest/base_loader'
require 'larrow/runner/manifest/configuration'

module Larrow
  module Runner
    # support multiple manifest style, such as travis, larrow, etc...
    module Manifest
      # Adapters is a set of class to adapt different manifest style.
      # There isn't Adapter module, these classes are under Manifest module.
      autoload :Travis, 'larrow/runner/manifest/adapter/travis'
      autoload :Larrow, 'larrow/runner/manifest/adapter/larrow'
      autoload :Blank, 'larrow/runner/manifest/adapter/blank'

      extend self

      def configuration source_accessor
        [ Travis, Larrow, Blank ].each do |clazz|
          configuration = clazz.new(source_accessor).load
          return configuration if configuration
        end
      end

      def add_base_scripts configuration,source_accessor
        lines = <<-EOF
#{package_update}
#{bashrc_cleanup}
        EOF
        scripts = lines.split(/\n/).map{|s| Script.new s}
        configuration.insert_to_step :init, scripts
        configuration.insert_to_step :prepare, Script.new(
          source_accessor.source_sync_script
        )
      end

      def package_update
        <<-EOF
apt-get update -qq
apt-get install git libssl-dev build-essential curl libncurses5-dev -y -qq
        EOF
      end

      # remove PS1 check, for user to make ssh connection without tty
      def bashrc_cleanup
        "sed '/$PS1/ d' -i /root/.bashrc"
      end
    end
  end
end
