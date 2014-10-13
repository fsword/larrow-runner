gem 'pry', '0.10.0'
gem 'pry-nav', '0.2.4'
require 'pry'
require 'pry-nav'
module Larrow::Runner
  class Manager
    include Service

    attr_accessor :vcs
    attr_accessor :app
    def initialize target_url
      signal_trap
      self.vcs = Vcs.detect target_url
      self.app = Model::App.new vcs
    end

    def signal_trap
      trap('INT') do
        RunLogger.title 'try to release'
        release
        ::Kernel.exit
      end
    end

    def go
      handle_exception do
        app.allocate
        app.action :all
      end
    end

    def build_image
      handle_exception do
        app.allocate
        app.build_image
      end
    end

    def build_server
      handle_exception do
        app.allocate
        app.deploy
      end
    end

    def handle_exception
      yield
    rescue => e
      RunOption[:keep] = true if e.is_a?(ExecutionError)
      if e.is_a?(ExecutionError) && !debug?
        data = eval(e.message)
        RunLogger.level(1).err "Execute fail: #{data[:status]}"
        RunLogger.level(1).err "-> #{data[:errmsg]}"
      else
        debug? ? binding.pry : raise(e)
      end
    ensure
      if keep?
        store_resource
      else
        release
      end
    end

    def debug?
      RunOption.key? :debug
    end

    def keep?
      RunOption.key? :keep
    end

    def store_resource
      resource = app.resource
      File.write 'resource.yml', YAML.dump(resource)
      RunLogger.title 'store resource'
    end

    def cleanup
      resource = YAML.load(File.read 'resource.yml') rescue nil
      return if resource.nil?
      resource.each_pair do |k,array|
        case k
        when 'nodes'
          Node.cleanup array
        end
      end
      RunLogger.title 'resource cleaned'
    end

    def release
      RunLogger.title 'release resource'
      begin_at = Time.new
      if app && app.node
        app.node.destroy if @state != :release
      end
      during = sprintf('%.2f', Time.new - begin_at)
      RunLogger.level(1).detail "released(#{during}s)"
    end
  end
end
