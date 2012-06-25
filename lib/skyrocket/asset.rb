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

    def to_s
      name
    end

    def output_path
      @output_dir + "/" + @processor.post_process_name(@filename)
    end

    def content
      return @content ||= @processor.process(raw, name)
    end

    def raw
      File.read(File.join(@dir, @filename))
    end
  end
end

