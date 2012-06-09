require 'coffee-script'

module Skyrocket
  class CoffeescriptProcessor
    include Processor

    def extension; '.coffee'; end

    def process(contents)
      CoffeeScript.compile(contents)
    end
  end
end
