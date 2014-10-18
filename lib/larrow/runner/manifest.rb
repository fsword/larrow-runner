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
      autoload :Blank,  'larrow/runner/manifest/adapter/blank'

      extend self

      # options:
      #   :ignore_larrow : do not try to use larrow adapter
      #   :ignore_base_scripts : do not merge base scripts
      def configuration source_accessor, options={}
        adapters = [Travis, Blank]
        adapters.unshift Larrow unless options[:ignore_larrow]

        configuration = adapters.each do |clazz|
          c = clazz.new(source_accessor).load
          break c if c
        end
        return configuration if options[:ignore_base_scripts]
        
        add_base_scripts(configuration)
      end

      def add_base_scripts configuration,source_accessor
        configuration.add_source_sync source_accessor
        unless configuration.image
          lines = <<-EOF
#{package_update}
#{bashrc_cleanup}
          EOF
          scripts = lines.split(/\n/).map{|s| Script.new s}
          configuration.insert_to_step :init, scripts
        end
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
