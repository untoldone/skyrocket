require 'erb'

module Skyrocket
  class ErbProcessor
    include Processor

    def extension; '.erb'; end

    def process_contents(contents, name)
      template = ERB.new(contents, nil, '-', '@out')
      results = template.result(get_binding { |name=nil| '' })
      if(@layout)
        outer_contents = asset_factory.from_name(@layout).raw
        outer_template = ERB.new(outer_contents, nil, '-', '@out')
        results = outer_template.result(get_binding do |name=nil|
          if name == nil
            results
          else
            cf[name.to_sym] || ''
          end
        end)
      end
      results
    end

    def get_binding
      binding
    end

    def layout(name)
      @layout = name
      nil
    end

    def stylesheet_link_tag(path)
      "<link rel=\"stylesheet\" href=\"#{resolve(path)}\">"
    end

    def javascript_include_tag(path)
      "<script src=\"#{resolve(path)}\"></script>"
    end

    def link_to(content, path, options = Hash.new)
      opt_s = to_opt_s(options)
      "<a href=\"#{resolve(path)}\"#{opt_s}>#{content}</a>"
    end

    def image_tag(path, options)
      opt_s = to_opt_s(options)
      "<img src=\"#{resolve(path)}\"#{opt_s} />"
    end

    def href(path)
      resolve(path)
    end

    def content_for(key)
      # swap current ERB output buffer with a 'fake' buffer
      # otherwise calling yield will write contents of block
      # to ERB results output
      old = @out
      @out = ''
      results = yield.chomp
      @out = old
      cf[key.to_sym] = results
      nil
    end

    def render(asset_name)
      contents = asset_factory.from_name(asset_name).raw
      old = @out # save current ERB buffer
      @out = ''
      template = ERB.new(contents, nil, '-', '@out')
      results = template.result(get_binding do |name=nil|
        if name == nil
          results
        else
          cf[name.to_sym]
        end
      end)
      @out = old
      results
    end

  private
    def resolve(path)
      if(path.start_with?("/") || path =~ /^\w+:\/\//)
        path
      else
        base_url == '/' ? "#{base_url}#{path}" : "#{base_url}/#{path}"
      end
    end

    def cf
      @content_for ||= Hash.new
    end

    def to_opt_s(options)
      opt_s = options.keys.map{ |k| "#{k}=\"#{options[k]}\"" }.join(' ')
      opt_s = " " + opt_s unless opt_s == ''
    end
  end
end
