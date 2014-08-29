module Larrow
  module Runner
    module Service
      autoload :Cloud,    'larrow/runner/service/cloud'
      autoload :Executor, 'larrow/runner/service/executor'
      def cloud
        @cloud ||= Cloud.new
      end
    end
  end
end
