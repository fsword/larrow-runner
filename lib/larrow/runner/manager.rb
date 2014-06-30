require 'larrow/runner/model/app'
require 'larrow/runner/model/node'

module Larrow
  module Runner
    class Manager
      include Service

      attr_accessor :target_url
      attr_accessor :app
      def initialize target_url
        self.target_url = Vcs.formatted target_url
      end

      def go
        self.app = Model::App.new target_url
        allocate app
        app.prepare
        app.action
        puts 'do script according .larrow'
        release app
      end

      def allocate app
        app.assign node: Model::Node.new(*vm.create.first)
      end

      def release app
        app.node.tap do |node|
          node.instance.destroy
          node.eip.destroy
        end
      end
    end
  end
end
