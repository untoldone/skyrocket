module Skyrocket
  module Processor
    def extension
      raise NotImplimentedError.new("must impliment #{caller[0][/`.*'/][1..-2]} for #{self.class.name}")
    end

    def process(contents, name)
      preprocess_contents(contents, name) if self.respond_to?(:preprocess_contents)
      process_contents(contents, name)
    end

    def process?(file)
      ext = File.extname(file)
      (ext =~ /#{extension}$/) != nil 
    end

    def post_process_name(file)
      file.chomp(extension)
    end

    def self.asset_factory=(asset_factory)
      @@af = asset_factory
    end

    def asset_factory
      @@af
    end

    def self.base_url=(base_url)
      @@bu = base_url
    end

    def base_url
      @@bu
    end
  end
end
