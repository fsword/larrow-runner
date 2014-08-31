require 'thor'
require 'yaml'

module Larrow
  module Runner
    class Build < ::Thor
      desc 'server <target_url>','setup the server environment'
      def server url
        puts "build server by #{url}"
      end
     
      desc 'image <LarrowFile>','setup environment and cache it as a image'
      def image file_path
        RunLogger.title '[Read larrow file]'
        content = File.read file_path
        config = YAML.load(content).with_indifferent_access
        RunLogger.level(1).detail "loaded from #{file_path}"
        if ImageBuilder.check config[:image_id]
          RunLogger.level(1).detail 'image has already be created.'
          return
        end
        image_id = ImageBuilder.from(config[:from]).run(config[:run]).build
        RunLogger.title '[Write image id]'
        # remove old image_id entry
        content = content.split(/\n/).select{|s| s =~ /^image_id: /}.join("\n")
        # add image_id entry
        content.gsub!(/\r?\n$/,'') << "\nimage_id: #{image_id}\n"
        File.write file_path, content
      end
    end

    class Command < ::Thor
      desc 'config','show all configuration'
      def config
        Config.generate
      end

      desc 'version','show version of larrow-runner'
      def version
        puts VERSION
      end

      desc 'go <target_url>','execute your app'
      long_desc <<-EOF
larrow will build a whole world for your application
EOF
      option :debug
      option :nocolor
      def go url
        Option.update options
        RunLogger.nocolor if Option.key? :nocolor
        Manager.new(url).go
      end
     
      desc 'build SUBCOMMAND', 'build your server or images'
      subcommand 'build', Build
    end

  end
end
