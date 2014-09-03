module Larrow::Runner::Cli
  class Build < ::Thor
    desc 'server <target_url>','setup the server environment'
    def server url
      puts "build server by #{url}"
    end

    desc 'image <LarrowFile>','setup environment and cache it as a image'
    long_desc <<-EOF
Reduce the time is very important for CI or other develop activity.  
There is a best practise to build a image as base system for the project.  
Larrow will help you to make it simple and reuse the configuration items
    EOF
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
end
