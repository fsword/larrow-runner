module Larrow
  module Runner
    module Service
      autoload :Vm, 'larrow/runner/service/vm'
      def vm
        @vm ||= Vm.new
      end
    end
  end
end
