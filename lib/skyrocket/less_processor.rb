require 'less'

module Skyrocket
  class LessProcessor
    include Processor

    def extension; '.less'; end

    def process_contents(contents, name)
      tree = parser.parse(contents)
      tree.to_css
    end

  private
    def parser
      @@parser ||= Less::Parser.new(:paths => asset_factory.asset_dirs + asset_factory.lib_dirs)
    end
  end
end
