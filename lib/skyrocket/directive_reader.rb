module Skyrocket
  class DirectiveReader
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

    def self.read_body(asset)
      split_parts(asset)[1]
    end
    
    def self.read_required(asset)
      split_parts(asset)[0]
    end

    def self.split_parts(asset)
      raw = asset.raw
      headers = raw[HEADER_PATTERN, 0].to_s.lines || [""]
      body = $' || raw
      headers = headers.each.map do |line|
        if directive = line[DIRECTIVE_PATTERN, 1]
          name, arg = Shellwords.shellwords(directive)
          arg if name == 'require'
        end
      end.compact
      [headers, body]
    end
  end
end
