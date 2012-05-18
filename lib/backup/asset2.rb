require 'pathname'

module Skyrocket
  class Asset
    PROCESSORS = [CoffeescriptProcessor.new, ErbProcessor.new, LessProcessor.new]

    private_class_method :new
    attr_reader :name, :filepath

    def initialize(base, asset_path)
      @base = base
      @asset_path = asset_path
      @asset_manager = asset_manager
      @filepath = base + asset_path
      PROCESSORS.each do |processor|
        if processor.process?(@asset_path)
          @processor = processor
          @name = processor.post_process_name
          break
        end
      end
      all[@filepath] = self
    end

    Asset.load(dir, file.split(dir)[1], type, self)

    def self.cache(dir, filename, type)
      nodes = [filename]        # list of nodes discovered but not yet searched
      requires = Array.new      # list of ordered dependencies
      current_path = Array.new  # stack to track current dep tree
      until(nodes.empty?) do
        current = nodes.shift
        # \n used as marker for 'end of level of tree'
        if(current == '\n')
          # go up a level in dep tree
        elsif(current_path.include?(current))
          raise 'circular dependency in requires!'
        elsif(requires.include?(current))
          # skip node, already required
        else
          # keep depth first searching!

          nodes = + '\n' + nodes
        end
      end


        current_node = nodes.shift
        current_path.push(current_node)
        r_dir, r_file = resolver.resolve_parts(current_node)
        a = AssetLoader.new(r_dir + r_file)
        req = a.requires
        if(req.length > 0)
          nodes 
        else
          
        end
      end
    end

    def self.node_children(node)
      r_dir, r_file = resolver.resolve_parts(current_node)
      a = AssetLoader.new(r_dir + r_file)
    end

    def set.asset_manager=(asset_manager)
      @@am = asset_manager
    end

    def required_assets
      raise NotImplementedError
    end

  private
    def self.resolver
      @@resolver ||= relative_resolver.new(@@am)
    end

    def self.all
      @@all ||= Hash.new
    end
  end
end