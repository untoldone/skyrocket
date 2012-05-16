require 'optparse'
require 'skyrocket'

module Skyrocket
  # CMD execution controller
  class Cmd
    COMMANDS = %w(compile watch)

    def initialize(argv)
      @options = {
        :asset_dirs => Array.new,
        :lib_dirs => Array.new,
        :output_dir => './public',
        :base_url => '/',
        :style => :raw
      }

      parser.parse!(argv)
      @command = argv.shift
      @arguments = argv

      @options[:assets] << './assets/public' unless @options[:asset_dirs].length
      @options[:assets_lib] << './assets/lib' unless @options[:lib_dirs].length
    end

    def parser
      @parser ||= OptionParser.new do |opts|
        opts.banner = "Usage: skyrocket [options] #{COMMANDS.join('|')}"

        opts.separator ""
        opts.separator "Options:"
        opts.on("-s", "--style MODE", "Compilation style ('concat' for concat only, 'minify' for concat and minification, default 'raw' for neither)") do |style|
          @options[:style] = style.to_sym
        end
        opts.on("-b", "--base URL", "Base url for assets location/ link generation") { |base| @options[:base_url] = base }
        opts.on("-a", "--asset DIR", "Assets directory. Use more than once for multiple assets directories") { |asset| @options[:asset_dirs] << asset }
        opts.on("-l", "--asset-lib DIR", "Asset lib directory. Use more than once for multiple lib directories") { |lib| @options[:lib_dirs] << lib }
        opts.on("-o", "--output DIR", "Output directory for compiled assets.") { |output| @options[:output_dir] = output}

        opts.on_tail("-h", "-?", "--help", "Show this message") { puts opts; exit }
        opts.on_tail("-v", "--version", "Show version") { puts Skyrocket::VERSION; exit }
      end
    end

    def run
      if COMMANDS.include?(@command)
        am = AssetManager.new(@options)
        case @command
        when "compile"
          am.compile
        when "watch"
          am.watch
        end
      elsif @command.nil?
        puts "Command required"
        puts @parser
        exit 1
      else
        abort "Unknown command: #{@command}. Valid commands include: #{COMMANDS.join(', ')}"
      end
    end
  end
end
