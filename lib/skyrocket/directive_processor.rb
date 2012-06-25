module Skyrocket
  module DirectiveProcessor

    def preprocess_contents(contents, name)
      asset = asset_factory.from_name(name)
      start = AssetDependency.new(asset, asset_factory)
      deps = DependencySearcher.deps(start)
      deps.map do |r|
        DirectiveReader.read_body(asset_factory.from_name(r))
      end.join("\n")
    end
  end
end
