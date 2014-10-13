module Larrow::Runner
  module Cli
    class Tools < ::Thor
      desc 'dump [URL]','convert and dump configuration of the project'
      long_desc <<-EOF.gsub("\n", "\x5")
Read other CI file(eg:.travis.yml), conert to larrow style and dump to STDOUT. 
You can save it as .larrow.yml on the project root folder.
      EOF
      def dump url
        vcs = Vcs.detect url
        configuration = vcs.configuration false
        puts configuration.dump
      end
      
      desc 'cleanup resource','cleanup all resource in Resource.yml'
      long_desc <<-EOF.gsub("\n", "\x5")
Read .larrow.resource from current directory, and release all resources.
resource: instance, eip, etc...
      EOF
      def cleanup
        Manager.cleanup
      end
    end
  end
end
