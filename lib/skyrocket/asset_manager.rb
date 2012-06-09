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
      @al = AssetLocator.new(@af)
      Processor.asset_factory = @af
      Processor.base_url = @base_url
    end

    def compile(&block)
      update_public(&block)
    end

    def watch(&block)
      gem 'listen', '>=0.4.2'
      require 'listen'

      update_public(&block)

      Listen.to(*(@asset_dirs + @lib_dirs)) do |modified, added, removed|
        (modified + added).each { |am| process_change(@af.build_asset(am), &block) }
        removed.each do |del|
          as = @af.build_asset(del)
          process_deleted(as.output_path, &block)
        end
      end
    end

  private
    def update_public(&block)
      @al.missing_asset_paths.each { |p| process_deleted(p, &block) }
      @al.all_assets.each { |a| process_change(a, &block) }
    end

    def process_change(asset)
      case @aw.write(asset)
      when :created
        yield(:created, asset.name) if block_given?
      when :modified
        yield(:modified, asset.name) if block_given?
      end
    end

    def process_deleted(path)
      @aw.delete(path)
      yield(:deleted, path.gsub(@output_dir + '/', '')) if block_given?
    end
  end
end
