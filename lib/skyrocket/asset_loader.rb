require 'shellwords'

# components of this file were borrowed from ruby sprokets, https://github.com/sstephenson/sprockets
module Skyrocket
  class AssetLoader
    HEADER_PATTERN = /
      \A (
        (?m:\s*) (
          (\/\* (?m:.*?) \*\/) |
          (\#\#\# (?m:.*?) \#\#\#) |
          (\/\/ .* \n?)+ |
          (\# .* \n?)+
        )
      )+
    /x

    DIRECTIVE_PATTERN = /
      ^ [\W]* = \s* (\w+.*?) (\*\/)? $
    /x

    attr_reader :headers, :body

    def initialize(filepath)
      raw = File.read(filepath)
      @headers = raw[HEADER_PATTERN, 0].lines || [""]
      @body   = $' || data
      # Ensure body ends in a new line
      @body  += "\n" if @body != "" && @body !~ /\n\Z/m
    end

    def requires
      @requires ||= @headers.each.map do |line|
        if directive = line[DIRECTIVE_PATTERN, 1]
          name, arg = Shellwords.shellwords(directive)
          arg if name == 'require'
        end
      end.compact
    end
  end
end