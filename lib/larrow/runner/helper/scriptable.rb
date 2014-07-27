module Larrow
  module Runner
    module Helper
      module Scriptable
        def strong
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
