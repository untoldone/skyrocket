require 'fileutils'

module Skyrocket
  class AssetManager
    attr_reader :asset_dirs, :lib_dirs, :output_dir, :base_url, :style

    def initialize(options)
      @asset_dirs = options[:asset_dirs].map{ |ad| Pathname.new(ad).relative? ? File.join(Dir.pwd, ad) : ad }
      @lib_dirs = options[:lib_dirs].map{ |ad| Pathname.new(ld).relative? ? File.join(Dir.pwd, ld) : ld }
      @output_dir = Pathname.new(options[:output_dir]).relative? ? File.join(Dir.pwd, options[:output_dir]) : options[:output_dir]
      @base_url = options[:base_url]
      @style = options[:style]
    end

    def asset(name)
      raise NotImplementedError.new
    end

    def asset_by_path(path)
      raise NotImplementedError.new
    end

    def application
      AssetApplication.new(self)
    end

    def compile
      raise NotImplementedError.new
    end

    def watch
      raise NotImplementedError.new
    end
  private
    def scan_assets
      @asset_dirs.each { |dir| scan_asset_dir(dir, :asset) }
      @lib_dirs.each { |dir| scan_asset_dir(dir, :lib) }
    end

    def scan_asset_dir(dir, type)
      Dir["#{dir}/**/*"].map do |file|
        Asset.cache(dir, file.split(dir)[1], type, self)
      end
    end
  end
end
