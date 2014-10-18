require 'logger'

module Larrow::Runner
  # usage:
  # logger = Larrow::Runner::Logger filename
  # logger.level(3).color('red').info 'hello'
  # logger.level(3).title 'hello'
  # logger.level(3).detail 'hello'
  class Logger
    def initialize logger, level:nil, color:'green'
      @inner_logger = if logger.is_a? ::Logger
                        logger
                      else
                        ::Logger.new logger
                      end
      @inner_logger.formatter = proc do |_severity, datetime, _progname, msg|
           "[#{datetime.strftime('%H:%M:%S')}] #{msg}\n"
      end
      @level = level
      @color = color
    end

    def nocolor
      @color = nil
    end

    def level level
      Logger.new @inner_logger, level: level, color: @color
    end

    def color color
      return self if RunOption.key? :nocolor # skip color when no color
      Logger.new @inner_logger, level: @level, color: color
    end

    def info msg
      indent = "  " * (@level || 0)
      wrapped = wrap_color msg
      @inner_logger.info "#{indent}#{wrapped}"
    end

    def title msg
      color('yellow').info msg
    end

    def detail msg
      color('magenta').info msg
    end

    def err msg
      color('red').info msg
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
