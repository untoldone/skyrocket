require 'fileutils'
require 'skyrocket/file_ext'

module Skyrocket
  class AssetWriter
    def write(asset)
      if(File.exist?(asset.output_path))
        existing = File.read(asset.output_path)
        if existing != asset.content
          File.write_file(asset.output_path, asset.content)
          :modified
        else
          :no_change
        end
      else
        dirname = File.dirname(asset.output_path)
        FileUtils.mkdir_p(dirname) 
        File.write_file(asset.output_path, asset.content)
        :created
      end
    end
  end
end
