module Larrow
  module Runner
    # support multiple manifest style, such as travis, larrow, etc...
    module Manifest
      # Adapters is a set of class to adapt different manifest style.
      # There isn't Adapter module, these classes are under Manifest module.
      autoload :Configuration, 'larrow/runner/manifest/configuration'
      autoload :Travis, 'larrow/runner/manifest/adapter/travis'

      def self.load_configuration source_accessor
        @configuration ||= begin
                             [ Travis, Larrow ].each do |clazz|
                               configuration = 
                                 clazz.new(source_accessor).load
                               break configuration if configuration
                             end
                           end
      end

      class Base
        attr_accessor :source_accessor
        def initialize source_accessor
          self.source_accessor = source_accessor
        end

        def load
          content = source_accessor.get self.class.const_get 'CONFIG_FILE'
          return nil if content.nil?

          self.configuration = Configuration.new
          parse(content)
        end

      end
    end
  end
end
require 'larrow/runner/manifest/configuration'
