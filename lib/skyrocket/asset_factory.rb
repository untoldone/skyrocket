module Skyrocket
  class AssetFactory
    def initialize(asset_dirs, lib_dirs = [], output_dir)
      @asset_dirs = asset_dirs
      @lib_dirs = lib_dirs
      @output_dir = output_dir
      @pf = ProcessorFactory.new
    end

    def build_asset(filepath)
      dir, file = parts(filepath)
      @pf.process?(file)
      Asset.new(dir, file, @output_dir)
    end

    def from_name(name)
      @@am.asset_dirs.each do |dir|
        if(File.exist?(File.join(dir, name)))
          return Asset.new(dir, file, @output_dir)
        else
          PROCESSORS.each do |processor|
            filename = File.join(dir, name) + processor.extname
            return new (filename) if File.exist?(filename)
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
  end
end
