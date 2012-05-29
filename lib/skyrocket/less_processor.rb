require 'less'

module Skyrocket
  class LessProcessor
    include Processor

    def extension; '.less'; end

    def process(contents)
      tree = parser.parse(contents)
      tree.to_css
    end

  private
    def parser
      @parser ||= Less::Parser.new(:paths => asset_manager.asset_dirs + asset_manager.lib_dirs)
    end
  end
end