module Larrow
  module Runner
    class World

      attr_accessor :target_url, :scm
      attr_accessor :node
      def initialize target_url
        self.target_url = target_url
      end

      def go
        # TODO
        self.scm =  Scm.parse target_url
        self.node = scm.gen_node
        node.assign
        node.checkout
        node.prepare
        node.default_action
        
        puts 'do script according .larrow'
        puts 'destroy every resource if it is ok'
      end

        new.tap{|w| w.instances = Instance.new url}
      end
    end
  end
end
