module Skyrocket
  module Processor
    def extension
      raise NotImplimentedError.new("must impliment #{caller[0][/`.*'/][1..-2]} for #{self.class.name}")
    end

    def process?(file)
      File.extname(file) == extension
    end

    def post_process_name(file)
      file.chomp(File.extname(file))
    end
  end
end