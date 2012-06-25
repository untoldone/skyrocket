module Skyrocket
  class DependencySearcher
    def self.deps(node)
      build_deps(node)
    end

    def self.build_deps(node, chain = Array.new)
      results = Array.new
      raise CircularReferenceError.new if chain.include?(node.name)
      chain = chain.clone << node.name
      node.children.each do |child|
        results += build_deps(child, chain)
      end
      (results << node).uniq{ |n| n.name }
    end
  end
end
