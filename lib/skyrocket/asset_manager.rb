require 'pathname'

module Skyrocket
  class AssetManager
    attr_reader :asset_dirs, :lib_dirs, :output_dir, :base_url, :style

    def initialize(options)
      @asset_dirs = options[:asset_dirs].map{ |ad| File.expand_path(ad) }
      @lib_dirs = options[:lib_dirs].map{ |ld| File.expand_path(ld) }
      @output_dir = File.expand_path(options[:output_dir])
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

      begin
        update_public(&block)
      rescue Exception => e
        puts e.message
        puts e.backtrace
      end

      Listen.to(*(@asset_dirs)) do |modified, added, removed|
        begin
          (modified + added).each { |am| process_change(@af.build_asset(am), &block) }
          removed.each do |del|
            as = @af.build_asset(del)
            process_deleted(as.output_path, &block)
          end
        rescue Exception => e
          puts e.message
          puts e.backtrace
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
