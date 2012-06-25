module Skyrocket
  class EmptyProcessor
    include Processor

    def extension; ''; end
    def process_contents(contents, name); contents; end;
  end
end
