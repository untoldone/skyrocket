require 'erb'

module Skyrocket
  class ErbProcessor
    include Processor

    def extension; '.erb'; end

    def process(contents)
      template = ERB.new(contents)
      template.result(binding)
    end
  end
end