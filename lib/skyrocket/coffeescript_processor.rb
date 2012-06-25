require 'coffee-script'

module Skyrocket
  class CoffeescriptProcessor
    include Processor
    include DirectiveProcessor

    def extension; '.coffee'; end

    def process_contents(contents, name)
      CoffeeScript.compile(contents)
    end
  end
end
