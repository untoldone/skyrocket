require 'pathname'

module Skyrocket
  class Asset
    PROCESSORS = [CoffeescriptProcessor.new, ErbProcessor.new, LessProcessor.new]

    private_class_method :new
    attr_reader :name, :filepath

    def initialize(base, asset_path, asset_manager)
      @base = base
      @asset_path = asset_path
      @asset_manager = asset_manager
      @filepath = base + asset_path
      PROCESSORS.each do |processor|
        if processor.process?(@asset_path)
          @processor = processor
          @name = processor.post_process_name
          break
        end
      end
      all[@filepath] = self
    end

    Asset.load(dir, file.split(dir)[1], type, self)

    def self.cache(dir, filename, type, asset_manager)
      
    end

    def required_assets
      raise NotImplementedError
    end

  private
    def self.all
      @@all ||= Hash.new
    end
  end
end