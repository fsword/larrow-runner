require 'larrow/runner/model/app'
require 'larrow/runner/model/node'

module Larrow
  module Runner
    class ImageBuilder
      include Service

      attr_accessor :base_image
      attr_accessor :runs
      def self.from base_image
        new(base_image)
      end

      def initialize base_image
        self.base_image = base_image
        self.runs = []
      end

      def run *scripts
        scripts.flatten.map do |s|
          self.runs << Manifest::Script.new(s)
        end
        self
      end

      def build
        raise ArgumentError, 'Which image should I based on?' if base_image.nil?
        RunLogger.title '[Make a blank node]'
        node = Model::Node.new *cloud.create(image_id: base_image).first
      
        RunLogger.title '[Modify by `run` scripts]'
        runs.each do |script|
          node.execute script
        end

        RunLogger.title '[Build Image]'
        node.stop
        new_image = cloud.create_image node.instance.id
        RunLogger.level(1).detail "New Image Id: #{new_image.id}"

        RunLogger.title '[Cleanup]'
        node.destroy

      end
    end
  end
end
