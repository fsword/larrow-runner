module Larrow
  module Runner
    class Manager

      attr_accessor :target_url, :scm
      attr_accessor :root
      def initialize target_url
        self.target_url = target_url
      end

      def go
        # TODO
        scm =  Scm.parse target_url
        self.root = scm.gen_app # 递归创建nodes，并在node中设定scm属性
        allocate_resource root.all_apps
        node.checkout
        node.prepare
        node.default_action
        
        puts 'do script according .larrow'
        puts 'destroy every resource if it is ok'
      end

      private
      def allocate_resource apps
        args = Service.vm.gen count: apps.count
        args.each_with_index do |arg, index|
          apps[index].assign arg
        end
      end
    end
  end
end
