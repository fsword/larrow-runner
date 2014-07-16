module Larrow
  module Runner
    # support multiple manifest style, such as travis, larrow, etc...
    module Manifest
      # Adapters is a set of class to adapt different manifest style.
      # There isn't Adapter module, these classes are under Manifest module.
      autoload :Configuration, 'larrow/runner/manifest/configuration'
      autoload :Travis, 'larrow/runner/manifest/adapter/travis'

      def self.load_configuration source_accessor
        @configuration ||= begin
                             [ Travis, Larrow ].each do |clazz|
                               configuration = 
                                 clazz.new(source_accessor).load
                               break configuration if configuration
                             end
                           end
      end

      class Base
        attr_accessor :source_accessor
        def initialize source_accessor
          self.source_accessor = source_accessor
        end

        def load
          content = source_accessor.get self.class.const_get 'CONFIG_FILE'
          return nil if content.nil?

          self.configuration = Configuration.new
          configuration.put_to_step :init, base_scripts
          
          parse(content)
        end

        def base_scripts
          args = {nfs_ip: '10.50.27.146', target: '/media/cdrom'}

          ['apt-get update',
           'apt-get install git libssl-dev nfs-common portmap -q -y',
           'echo blacklist rpcsec_gss_krb5 > /etc/modprobe.d/larrow-blacklist.conf',
           'mount %{nfs_ip}:/opt %{target}',
           'cp -a %{target}/usr/local/rvm /usr/local/rvm',
           'cp -a %{target}/usr/local/bin/* /usr/local/bin/',
           'cp -a %{target}/home/* $HOME/',
           'ln -s %{target}/install /opt/install',
           source_accessor.source_sync_script
          ].map do |s|
            Script.new s, args: args
          end
        end
      end
    end
  end
end
require 'larrow/runner/manifest/configuration'
