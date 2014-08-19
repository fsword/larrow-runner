require 'larrow/runner/model/app'
require 'larrow/runner/model/node'

module Larrow
  module Runner
    class Manager
      include Service

      attr_accessor :vcs
      attr_accessor :app
      def initialize target_url
        @state = :init
        signal_trap
        self.vcs = Vcs.parse target_url
      end

      def signal_trap
        trap('INT') do
          RunLogger.color('red').info 'try to release'
          release
          ::Kernel.exit
        end
      end

      def go
        preload
        allocate
        app.action
      ensure
        release
      end

      def preload
        RunLogger.color('yellow').info 'load configuration'
        self.vcs.load_configuration
        @state = :preload
      end

      def allocate
        RunLogger.color('yellow').info 'allocating resource'
        begin_at = Time.new
        self.app = Model::App.new vcs
        self.app.assign node: Model::Node.new(*vm.create.first)
        during = sprintf('%.2f', Time.new - begin_at)
        RunLogger.level(1).color('blue').info "allocated(#{during}s)"
        @state = :allocate
      end

      def release
        RunLogger.color('yellow').info 'releasing resource'
        begin_at = Time.new
        app.node.destroy if @state != :release
        during = sprintf('%.2f', Time.new - begin_at)
        RunLogger.level(1).color('blue').info "released(#{during}s)"
        @state = :release
      end
    end
  end
end
