module Larrow::Runner
  module Model
    class App
      include Service
      attr_accessor :vcs, :node, :configuration
      def initialize vcs, attributes={}
        self.vcs = vcs
        self.configuration = Manifest.configuration vcs
        self.assign attributes unless attributes.empty?
      end

      def assign arg
        arg.each_pair do |k,v|
          self.send "#{k}=".to_sym, v
        end
      end

      def action group
        verbose = RunOption.key?(:debug) ? true : nil
        configuration.steps_for(group) do |a_step|
          RunLogger.title "[#{a_step.title}]"
          begin_at = Time.new
          a_step.run_on node, verbose: verbose
          during = sprintf('%.2f',Time.new - begin_at)
          RunLogger.level(1).info "#{a_step.title} complete (#{during}s)"
        end
      end

      def allocate
        RunLogger.title 'allocate resource'
        begin_at = Time.new
        option = {image_id: configuration.image}
        self.node = Node.new(*Session.cloud.create(option).first)
        during = sprintf('%.2f', Time.new - begin_at)
        RunLogger.level(1).detail "allocated(#{during}s)"
      end

      def build_image
        action :image
        node.stop
        new_image = Session.cloud.create_image node.instance.id
        RunLogger.level(1).detail "New Image Id: #{new_image.id}"
        [
          "To reduce the system setup, you might want to change larrow.yml.",
          "  You can replace init step with the follow contents:",
          "  image: #{new_image.id}"
        ].each{|s| RunLogger.level(1).detail s}

        new_image
      end

      def deploy
        action :deploy
        RunLogger.level(1).detail "application is deploy on: #{node.host}"
        node
      end

      def dump
        {nodes:[node.dump]}
      end
    end
  end
end
