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
      @af = AssetFactory.new(@asset_dirs, @lib_dirs, @output_dir)
      @aw = AssetWriter.new
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


      # Create/ Modify existing files
      Asset.all_public.each do |asset|
        case @aw.write(asset)
        when :created
          yield(:created, asset.name) if block_given?
        when :modified
          yield(:modified, asset.name) if block_given?
        end
      end
    end

    def process_removed(removed)
      removed.each do |file|
        asset = @af.build_asset(file)
        yield(:deleted, asset.name) if block_given?
        @aw.delete(asset)
      end
    end

    def process_added(added)
      added.each do |file|
        asset = @af.build_asset(file)
        yield(:created, asset.name) if @aw.write(asset) && block_given?
      end
    end

    def process_modified(modified)
      modified.each do |file|
        asset = Asset.new(file)
        yield(:modified, asset.name) if @aw.write(asset) && block_given?
      end
    end
  end
end
