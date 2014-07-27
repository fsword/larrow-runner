module Larrow
  module Runner
    module Helper
      module Scriptable
        def title
          color 33
        end

        def warn
          color 31
        end

        def detail
          color 35
        end

        def color code
          "\e[0;#{code}m#{to_s}\e[m"
        end
      end
    end
  end
end

String.send :include, Larrow::Runner::Helper::Scriptable

