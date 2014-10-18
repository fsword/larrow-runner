module Larrow::Runner
  module Vcs
    class Base
      attr_accessor :larrow_file

      def get filename
        raise 'not implement yet'
      end

      def update_source node, target_dir
        raise 'not implement yet'
      end

      def formatted_url
        raise 'not implement yet'
      end
    end
  end
end
