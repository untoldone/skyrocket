require 'pathname'

module Skyrocket
  class AssetManager
    attr_reader :asset_dirs, :lib_dirs, :output_dir, :base_url, :style

    def initialize(options)
      @asset_dirs = options[:asset_dirs].map{ |ad| Pathname.new(ad).realpath.to_s }
      @lib_dirs = options[:lib_dirs].map{ |ld| Pathname.new(ld).realpath.to_s }
      @output_dir = Pathname.new(options[:output_dir]).realpath.to_s
      @base_url = options[:base_url]
      @style = options[:style]
      Asset.cache_all(self)
    end

    def compile
      Asset.all_public.each { |asset| asset.write }
    end

    def watch(&block)
      gem 'listen', '>=0.4.2'
      require 'listen'
      Listen.to(*(@asset_dirs + @lib_dirs)) do |modified, added, removed| 
        process_removed(removed, &block)
        process_modified(modified, &block)
        process_added(added, &block)
      end
    end

  private
    def process_removed(removed)
      removed.each do |file|
        asset = Asset.new(file)
        compile_related(asset).each do |related|
          yield(:deleted, related.name) if block_given?
        end
        yield(:deleted, asset.name) if block_given?
        asset.delete
      end
    end

    def process_added(added)
      added.each do |file|
        asset = Asset.new(file)
        yield(:created, asset.name) if asset.write && block_given?
        compile_related(asset).each do |asset|
          yield(:modified, asset.name) if block_given?
        end
      end
    end

    def process_modified(modified)
      modified.each do |file|
        asset = Asset.new(file)
        yield(:modified, asset.name) if asset.write && block_given?
        compile_related(asset).each do |asset|
          yield(:modified, asset.name) if block_given?
        end
      end
    end

    def compile_related(asset)
      assets = asset.related
      assets.each { |asset| asset.write }
      assets
    end
  end
end
