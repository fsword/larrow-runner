module Larrow::Runner
  module Vcs
    class FileSystem < Base
      # path: absulute path of LarrowFile
      attr_accessor :project_folder
      def initialize project_folder
        self.project_folder = File.absolute_path project_folder
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
        invoke command
        invoke "ssh-keygen -R #{node.host} 2>&1"
      end

      def rsync_command user, host, target_dir
        ssh_path = '%s@%s:%s' % [user, host, target_dir]

        excludes = get('.gitignore').  # rsync exclude according .gitignore
          split(/[\r\n]/).             # 
          select{|s| s =~ /^[^#]/}.    # not commented
          compact.                     # not blank
          unshift('.git').             # .git itself is ignored
          map{|s| "--exclude '#{s}'" } # build rsync exclude arguments

        ssh_options = "-e 'ssh -o StrictHostKeyChecking=no'"

        rsync_options = "-az #{ssh_options} #{excludes.join ' '}"
        rsync_options += ' -v' if RunOption.key? :debug

        "rsync #{rsync_options} #{project_folder}/ '#{ssh_path}' 2>&1"
      end
      def invoke command
        `#{command}`.split(/\r?\n/).each do |msg|
          RunLogger.level(1).info msg
        end
      end

    end
  end
end
