module Larrow::Runner
  module Vcs
    class FileSystem < Base
      # path: absulute path of LarrowFile
      attr_accessor :project_folder
      def initialize path
        if File.file? path
          path  = File.absolute_path path
          self.larrow_file    = File.basename path
          self.project_folder = File.dirname path 
        else # directory
          self.project_folder = File.absolute_path path
        end
      end

      def formatted_url
        self.project_folder
      end

      def get filename
        file_path = "#{project_folder}/#{filename}"
        return nil unless File.exist? file_path

        File.read(file_path)
      end

      def update_source node, target_dir
        command = rsync_command node.user, node.host,target_dir
        invoke "ssh #{ssh_options} root@#{node.host} date"
        invoke command
        invoke "ssh-keygen -R #{node.host}"
      end

      def rsync_command user, host, target_dir
        ssh_path = '%s@%s:%s' % [user, host, target_dir]

        excludes = (get('.gitignore')||'').  # rsync exclude according .gitignore
          split(/[\r\n]/).                   # 
          select{|s| s =~ /^[^#]/}.          # not commented
          compact.                           # not blank
          unshift('.git').                   # .git itself is ignored
          map{|s| "--exclude '#{s}'" }       # build rsync exclude arguments

        rsync_options = "-az -e 'ssh #{ssh_options}' #{excludes.join ' '}"
        rsync_options += ' -v' if RunOption.key? :debug

        "rsync #{rsync_options} #{project_folder}/ '#{ssh_path}'"
      end
      
      def invoke command
        RunLogger.level(1).info command
        time = Time.new
        `#{command} 2>&1`.split(/\r?\n/).each do |msg|
          RunLogger.level(2).detail msg
        end
        RunLogger.level(1).detail "invoke time: #{Time.new - time}"
      end

      def ssh_options
        {
          'GSSAPIAuthentication'  => 'no',
          'StrictHostKeyChecking' => 'no',
          'LogLevel'              => 'ERROR'
        }.map do |k,v|
          "-o #{k}=#{v}" 
        end.join(' ')
      end
    end
  end
end
