module Skyrocket
  class ErbProcessor
    include Processor

    def extension; '.erb'; end

    def process(contents)
      contents
    end
  end
end