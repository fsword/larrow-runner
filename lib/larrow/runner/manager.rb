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
          Logger.info 'try to release'
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
        Logger.info '---------load configuration--------'
        self.vcs.load_configuration
        @state = :preload
      end

      def allocate
        Logger.info '---------allocating resource-------'
        begin_at = Time.new
        self.app = Model::App.new vcs
        self.app.assign node: Model::Node.new(*vm.create.first)
        during = sprintf('%.2f', Time.new - begin_at)
        Logger.info "---------allocated(#{during}s)--------"
        @state = :allocate
      end

      def release
        Logger.info '---------releasing resource--------'
        begin_at = Time.new
        app.node.destroy if @state != :release
        during = sprintf('%.2f', Time.new - begin_at)
        Logger.info "---------released(#{during}s)--------"
        @state = :release
      end
    end
  end
end
