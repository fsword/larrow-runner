module Larrow::Runner::Cli
  class Build < ::Thor
    include Larrow::Runner
    desc 'server <target_url>','setup the server environment'
    option :debug
    option :nocolor
    def server url
      RunOption.update options
      RunOption[:keep] = true
      RunLogger.nocolor if RunOption.key? :nocolor
      Manager.new(url).build_server
    end

    desc 'image <target_url>', 'build a base image for the project'
    long_desc <<-EOF
Reduce the time is very important for CI or other develop activity.  
There is a best practise to build a image as base system for the project.  
Larrow will help you to make it simple and reuse the configuration items
    EOF
    option :debug
    option :nocolor
    def image url
      RunOption.update options
      RunLogger.nocolor if RunOption.key? :nocolor
      Manager.new(url).build_image
    end

    desc 'on <LarrowFile>','build a image according to a file'
    long_desc <<-EOF
Like DockerFile, LarrowFile can help you to make it simple to build a base image'
    EOF
    def on file_path
      RunLogger.title '[Read LarrowFile]'
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
end
