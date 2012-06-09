module Skyrocket
  class EmptyProcessor
    include Processor

    def extension; ''; end
    def process(contents); contents; end;

  end
end
