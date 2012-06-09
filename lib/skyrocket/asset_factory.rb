module Skyrocket
  class AssetFactory
    attr_reader :asset_dirs, :lib_dirs, :output_dir
    def initialize(asset_dirs, lib_dirs = [], output_dir)
      @asset_dirs = asset_dirs
      @lib_dirs = lib_dirs
      @output_dir = output_dir
      @pf = ProcessorFactory.new
    end

    def build_asset(filepath)
      dir, file = parts(filepath)
      Asset.new(dir, file, @output_dir, @pf.processor(file))
    end

    def from_name(name)
      found = dir_search(name, @asset_dirs + @lib_dirs)
      if found.length > 0
        found.each do |file|
          if @pf.post_process_name(file) =~ /#{name}$/
            dir, file = parts(file)
            return Asset.new(dir, file, @output_dir, @pf.processor(file))
          end
        end
      end
      
      raise AssetNotFoundError
    end

  private
    def parts(filepath)
      dir = file_dir(filepath, @asset_dirs + @lib_dirs)
      file = filepath.gsub("#{dir}/", '')
      [dir, file]
    end

    def file_dir(filepath, dirs)
      dirs.each do |dir|
        if(filepath.start_with?(dir))
          return dir
        end
      end
      raise PathNotInAssetsError.new
    end

    def dir_search(part, dirs)
      found = Array.new 
      dirs.each do |dir|
        found += Dir[dir + "/" + part + ".*"]
      end
      found
    end
  end
end
