module Larrow
  module Runner
    module Service
      autoload :Vm, 'larrow/runner/service/vm'
      autoload :Executor, 'larrow/runner/service/executor'
      def vm
        @vm ||= Vm.new
      end
    end
  end
end
