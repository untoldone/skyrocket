require 'ruby-debug'
require 'fileutils'

module Skyrocket
  class Asset
    attr_reader :name

    PROCESSORS = [Skyrocket::CoffeescriptProcessor.new,
                  Skyrocket::ErbProcessor.new, 
                  Skyrocket::LessProcessor.new]

    def initialize(filepath)
      @filepath = filepath
      @@am.asset_dirs.each do |dir|
        if filepath.start_with?(dir)
          @dir = dir
          @name = filepath.split(dir + "/")[1]
          PROCESSORS.each do |processor|
            if processor.process?(@name)
              @processor = processor
              @name = processor.post_process_name(@name)
              break
            end
          end
          break
        end
      end

      @@am.lib_dirs.each do |dir|
        if filepath.start_with?(dir)
          @dir = dir
          @name = filepath.split(dir + "/")[1]
          PROCESSORS.each do |processor|
            if processor.process?(filepath)
              @processor = processor
              @name = processor.post_process_name(filepath)
              break
            end
          end
          break
        end
      end unless @name
    end

    def self.cache_all(asset_manager)
      @@am = asset_manager
      @@all = Hash.new
      asset_manager.asset_dirs.each do |asset_dir|
        file_list = Dir[asset_dir + "/**/*"].map{|a| File.expand_path(a)}
        file_list.each do |fpath|
          @@all[fpath] = Asset.new(fpath) if(File.file?(fpath))
        end
      end
    end

    def self.all_public
      @@all.values
    end

    def output_path
      @@am.output_dir + "/" + @name
    end

    def related
      []
    end

    def write
      cont = File.read(@filepath)
      cont = @processor.process(cont) if @processor
      if(File.exist?(output_path))
        existing = File.read(output_path)
        if existing != cont
          File.open(output_path, 'w') { |f| f.write(cont) }
          :modified
        else
          :no_change
        end
      else
        dirname = File.dirname(output_path)
        puts dirname
        FileUtils.mkdir_p(dirname) unless File.directory?(dirname)
        File.open(output_path, 'w') { |f| f.write(cont) }
        :created
      end
    end

    def delete

    end
  end
end