require 'optparse'
require 'fileutils'
require 'skyrocket'

module Skyrocket
  # CMD execution controller
  class Cmd
    COMMANDS = %w(compile init watch)

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

      @options[:asset_dirs] << './assets/public' unless @options[:asset_dirs].length > 0
      @options[:lib_dirs]   << './assets/lib'    unless @options[:lib_dirs].length > 0
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
        when "init"
          @options[:asset_dirs].each{ |dir| FileUtils.mkdir_p(dir) }
          @options[:lib_dirs].each{ |dir| FileUtils.mkdir_p(dir) }
          FileUtils.mkdir_p(@options[:output_dir])
        when "watch"
          begin
            am.watch do |action, asset_name|
              case action
              when :deleted
                puts "     \e[31;40m** Deleted  **\e[0m #{asset_name}"
              when :created
                puts "     \e[32;40m** Created  **\e[0m #{asset_name}"
              when :modified
                puts "     \e[33;40m** Modified **\e[0m #{asset_name}"
              end
            end
          rescue Gem::LoadError => e
            puts "'watch' command requires the gem '#{e.name}' of version '#{e.version}'' be installed."
          end
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
