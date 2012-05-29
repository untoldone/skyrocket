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

    def compile(&block)
      update_public(&block)
    end

    def watch(&block)
      gem 'listen', '>=0.4.2'
      require 'listen'

      update_public(&block)

      Listen.to(*(@asset_dirs + @lib_dirs)) do |modified, added, removed| 
        process_removed(removed, &block)
        process_modified(modified, &block)
        process_added(added, &block)
      end
    end

  private
    def update_public
      # Cleanup output directory
      out_cont = Dir[@output_dir + "/**/*"]
                    .map { |a| File.expand_path(a) }
                    .select { |b| File.file?(b) }
      asset_cont = Asset.all_public.map { |a| a.output_path }
      out_cont.select { |file| !asset_cont.include?(file) }
        .each do |out_file|
          yield(:deleted, out_file.sub(@output_dir + "/", '')) if block_given?
          File.delete(out_file)
        end

      # Remove empty directories in output dir
      Dir[@output_dir + '/**/*']
        .select { |d| File.directory? d }
        .select { |d| (Dir.entries(d) - %w[ . .. ]).empty? }
        .each   { |d| Dir.rmdir d }

      # Create/ Modify existing files
      Asset.all_public.each do |asset|
        case asset.write
        when :created
          yield(:created, asset.name) if block_given?
        when :modified
          yield(:modified, asset.name) if block_given?
        end
      end
    end

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
