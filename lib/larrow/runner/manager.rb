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
        self.vcs = Vcs.parse target_url
      end

      def go
        preload
        allocate
        app.action
        release
      end

      def preload
        self.vcs.load_configuration
        @state = :preload
      end

      def allocate
        self.app = Model::App.new vcs
        self.app.assign node: Model::Node.new(*vm.create.first)
        @state = :allocate
      end

      def release
        app.node.destroy if @state != :release
        @state = :release
      end
    end
  end
end
