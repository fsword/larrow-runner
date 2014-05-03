module Larrow
  module Runner
    class World

      attr_accessor :target_url, :scm
      def initialize target_url
        self.target_url = target_url
      end

      def go
        # TODO
        scm =  Scm.parse url
        # World.resources.map(&:assign)
        puts 'assign resource for this execution'
        puts 'check out the source code url'
        puts 'do script according .larrow'
        puts 'destroy every resource if it is ok'
      end

      def parse url
        new.tap{|w| w.instances = Instance.new url}
      end
    end
  end
end
