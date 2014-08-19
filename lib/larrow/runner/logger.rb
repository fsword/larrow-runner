require 'logger'

module Larrow::Runner
  # usage:
  # logger = Larrow::Runner::Logger filename
  # logger.level(3).color('red').info 'hello'
  class Logger
    def initialize logger, level:nil, color:nil
      @inner_logger = if logger.is_a? ::Logger
                        logger
                      else
                        ::Logger.new logger
                      end
      @level = level
      @color = color
    end

    def level level
      Logger.new @inner_logger, level: level, color: @color
    end

    def color color
      return self unless Option.key? :debug
      Logger.new @inner_logger, level: @level, color: color
    end

    def info msg
      indent = "  " * (@level || 0)
      wrapped = wrap_color msg
      @inner_logger.info "#{indent}#{wrapped}"
    end

    def wrap_color msg
      return msg if @color.nil?
      code = case @color.downcase
               when 'black'   then  '30'
               when 'red'     then  '31'
               when 'green'   then  '32'
               when 'yellow'  then  '33'
               when 'blue'    then  '34'
               when 'magenta' then  '35'
               when 'cyan'    then  '36'
               when 'white'   then  '37'
             end
      "\033[#{code}m#{msg}\033[0m"
    end
  end
end
