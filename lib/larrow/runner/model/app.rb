module Larrow::Runner::Model
  class App
    attr_accessor :vcs, :node, :configuration
    def initialize vcs, attributes={}
      self.vcs = vcs
      self.configuration = vcs.configuration
      self.assign attributes unless attributes.empty?
    end

    def assign arg
      arg.each_pair do |k,v|
        self.send "#{k}=".to_sym, v
      end
    end

    def action skip_test=false
      configuration.each_step(skip_test) do |a_step|
        RunLogger.title "[#{a_step.title}]"
        begin_at = Time.new
        a_step.scripts.each do |script|
          node.execute script
        end
        during = sprintf('%.2f',Time.new - begin_at)
        RunLogger.level(1).detail "#{a_step.title} complete (#{during}s)"
      end
    end
  end
end
