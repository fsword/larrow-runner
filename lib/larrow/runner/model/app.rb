module Larrow::Runner::Model
  class App
    include Larrow::Runner
    include Service

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

    def action group
      configuration.steps_for(group) do |a_step|
        RunLogger.title "[#{a_step.title}]"
        begin_at = Time.new
        a_step.scripts.each do |script|
          node.execute script
        end
        during = sprintf('%.2f',Time.new - begin_at)
        RunLogger.level(1).detail "#{a_step.title} complete (#{during}s)"
      end
    end

    def allocate
      RunLogger.title 'allocate resource'
      begin_at = Time.new
      self.node = Node.new(*cloud.create.first)
      during = sprintf('%.2f', Time.new - begin_at)
      RunLogger.level(1).detail "allocated(#{during}s)"
    end

    def build_image
      action :image
      node.stop
      new_image = cloud.create_image node.instance.id
      RunLogger.level(1).detail "New Image Id: #{new_image.id}"
    end

    def deploy
      action :deploy
      RunLogger.level(1).detail "application is deploy on: #{node.host}"
    end

  end
end
