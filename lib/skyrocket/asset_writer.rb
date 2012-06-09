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

    def delete(asset)
      File.delete(asset.output_path)
      dir_parts = asset.name.split(File::SEPARATOR)[0..-2]
      dir_parts.length.times do |index|
        neg_index = -1 - index
        path = File.join(asset.output_dir, dir_parts[0..neg_index].join(File::SEPARATOR)) 
        if Dir.entries(path).empty?
          Dir.rmdir(path)
        end
      end
    end
  end
end
