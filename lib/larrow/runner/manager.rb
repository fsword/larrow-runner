module Larrow
  module Runner
    class Manager
      include Service

      attr_accessor :target_url, :scm
      attr_accessor :app
      def initialize target_url
        self.target_url = target_url
      end

      def go
        # TODO
        scm =  Scm.parse target_url
        self.app = scm.gen
        allocate_resource app
        app.prepare
        app.default_action
        puts 'do script according .larrow'
        release_resource app
      end

      private
      def allocate_resource app
        app.assign node: vm.create.first
      end

      def release_resource app
        vm.destroy *app.node
      end
    end
  end
end
