require 'fileutils'
require 'digest/md5'

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
      @output_dir + "/" + output_name
    end

    def output_name
      digest = Digest::MD5.hexdigest(content)
      ppn = @processor.post_process_name(@filename)
      ext = File.extname(ppn)
      "#{ppn.chomp(ext)}_#{digest}#{ext}"
      "#{ppn.chomp(ext)}#{ext}"
    end

    def content
      begin
        return @content ||= @processor.process(raw, name)
      rescue Exception => e
        puts "Error processing: #{name}"
        raise
      end
    end

    def raw
      File.read(File.join(@dir, @filename))
    end
  end
end

