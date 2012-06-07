require 'ruby-debug'
require 'fileutils'

module Skyrocket
  class Asset
    attr_reader :name, :dir, :processor

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
              @processor = processor.class.new # make a new instance so we might write more thread safe code
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
              @processor = processor.class.new
              @name = processor.post_process_name(filepath)
              break
            end
          end
          break
        end
      end unless @name
    end

    def self.from_name(name)
      @@am.asset_dirs.each do |dir|
        if(File.exist?(File.join(dir, name)))
          return new(File.join(dir, name))
        else
          PROCESSORS.each do |processor|
            filename = File.join(dir, name) + processor.extname
            return new (filename) if File.exist?(filename)
          end
        end
      end
      nil
    end

    def self.cache_all(asset_manager)
      @@am = asset_manager
      PROCESSORS[0].asset_manager = asset_manager
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

    def content
      return @content if @content
      @content = File.read(@filepath)
      @content = @processor.process(@content) if @processor
      return @content
    end

    def raw
      File.read(@filepath)
    end

    def write
      if(File.exist?(output_path))
        existing = File.read(output_path)
        if existing != content
          File.open(output_path, 'w') { |f| f.write(content) }
          :modified
        else
          :no_change
        end
      else
        dirname = File.dirname(output_path)
        FileUtils.mkdir_p(dirname) unless File.directory?(dirname)
        File.open(output_path, 'w') { |f| f.write(content) }
        :created
      end
    end
  end
end

