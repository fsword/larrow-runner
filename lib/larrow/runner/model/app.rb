module Larrow
  module Runner
    module Model
      class App
        attr_accessor :source_url, :scm
        attr_accessor :host, :port, :user, :passwd
        def initialize source_url, scm
          self.source_url = source_url
          self.scm = scm
        end

        # It will include dependent apps
        # This method should be recursive
        def all_apps
          [self] 
        end

        def assign arg
          arg.each_pair do |k,v|
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
end
