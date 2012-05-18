require 'ruby-debug'

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

    end

    def self.all_public

    end

    def related
      []
    end

    def write
      true
    end

    def delete

    end
  end
end