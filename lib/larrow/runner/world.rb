module Larrow
  module Core
    class World
      def self.execute url
        # TODO
        world = parse url
        World.resources.map(&:assign)
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
