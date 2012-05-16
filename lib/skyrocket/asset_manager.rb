module Skyrocket
  class AssetManager
    def initialize(options)
      @asset_dirs = options[:asset_dirs]
      @lib_dirs = options[:lib_dirs]
      @output_dir = options[:output_dir]
      @base_url = options[:base_url]
      @style = options[:style]
    end

    def [](path)
      raise NotImplementedError 
    end

    def lookup_asset(lookup_asset)
      raise NotImplementedError
    end

    def application
      SquareApplication.new(self)
    end

    def compile
      raise NotImplementedError
    end

    def watch
      raise NotImplementedError
    end
  end
end