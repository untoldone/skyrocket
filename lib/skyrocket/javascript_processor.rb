module Skyrocket
  class JavascriptProcessor
    include Processor
    include DirectiveProcessor

    def extension; '.js'; end
    def post_process_name(file); file.chomp; end

    def process_contents(contents, name)
      contents
    end
  end
end
