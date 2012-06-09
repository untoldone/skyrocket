require 'fileutils'

module Skyrocket
  class Asset
    attr_reader :filename, :dir, :output_dir, :processor

    def initialize(dir, filename, output_dir, processor)
      @dir = dir
      @filename = filename
      @output_dir = output_dir
      @processor = processor
    end

    def name
      @processor.post_process_name(@filename)
    end

    def output_path
      @output_dir + "/" + @processor.post_process_name(@filename)
    end

    def content
      return @content if @content
      @content = raw 
      @content = @processor.process(@content) if @processor
      return @content
    end

    def raw
      File.read(File.join(@dir, @filename))
    end
  end
end

