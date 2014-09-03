require 'larrow/runner/model/app'
require 'larrow/runner/model/node'

module Larrow
  module Runner
    class Manager
      include Service

      attr_accessor :vcs
      attr_accessor :app
      def initialize target_url
        signal_trap
        self.vcs = Vcs.detect target_url
      end

      def signal_trap
        trap('INT') do
          RunLogger.title 'try to release'
          release
          ::Kernel.exit
        end
      end

      def go
        preload
        allocate
        app.action
      rescue Exception
        binding.pry if RunOption.key? :debug
      ensure
        release
      end

      def preload
        RunLogger.title 'load configuration'
        self.vcs.load_configuration
      end

      def allocate
        RunLogger.title 'allocate resource'
        begin_at = Time.new
        node = Model::Node.new(*cloud.create.first)
        self.app = Model::App.new vcs, node: node
        during = sprintf('%.2f', Time.new - begin_at)
        RunLogger.level(1).detail "allocated(#{during}s)"
      end

      def release
        RunLogger.title 'release resource'
        begin_at = Time.new
        if app.node
          app.node.destroy if @state != :release
        end
        during = sprintf('%.2f', Time.new - begin_at)
        RunLogger.level(1).detail "released(#{during}s)"
      end
    end
  end
end
