require 'skyrocket/dir_ext'

module Skyrocket
  class AssetLocator
    def initialize(asset_factory)
      @af = asset_factory
    end

    def all_assets
      dirs = @af.asset_dirs
      paths = Array.new
      dirs.each do |dir|
        paths += Dir.glob_files(dir + "/**/*")
      end
      paths.map do |p|
        begin
          @af.build_asset(p)
        rescue Exception => e
          puts "Error parsing: #{p}"
          raise
        end
      end
    end

    def missing_asset_paths
      out_cont = Dir.glob_files(@af.output_dir + "/**/*")
      assets = all_assets
      a_m = all_assets.inject(Hash.new) { |h, a| h[a.output_path] = a; h }
      out_cont.select { |file| !a_m.keys.include?(file) }
    end
  end
end

