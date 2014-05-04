module Larrow
  module Runner
    class Node
      attr_accessor :source_url
      attr_accessor :host, :port, :user, :passwd
      def initialize source_url
        self.source_url = source_url
      end
      
      def assign
        params = Cloud::Qingcloud.gen 1
        params.each_pair do |k,v|
          self.send "#{k}=".to_sym, v
        end
      end

      def checkout
      end

      def prepare
      end

      def default_action
      end

    end
  end
end
