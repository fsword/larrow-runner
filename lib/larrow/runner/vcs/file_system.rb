require 'faraday'

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
      File.read(file_path)
    end

    def update_source node, target_dir
      command = rsync_command node.user, node.host,target_dir
      `#{command}`.split(/\r?\n/).each do |msg|
        RunLogger.level(1).info msg
      end

      # update source:
      #   node.host + node.user
      #   from 
      #     project_folder
      #   to
      #     target_dir
      # TODO
    end

    def rsync_command user, host, target_dir
      ssh_path = '%s@%s:%s' % [user, host, target_dir]

      excludes = get('.gitignore').split(/[\r\n]/).select do |s|
        ( s =~ /^[^#]/ ) && s.strip.size > 0
      end.map do |s|
        "--exclude '#{s}'"
      end.join ' '
    
      if RunOption.key? :debug
        rsync_options = "-avz -e ssh #{excludes}"
      else
        rsync_options = "-az -e ssh #{excludes}"
      end
      "rsync #{rsync_options} #{project_folder}/ '#{ssh_path}'"
    end
  end
  end
end
