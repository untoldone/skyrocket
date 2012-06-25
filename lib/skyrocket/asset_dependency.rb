module Skyrocket
  class AssetDependency
    attr_reader :asset

    def initialize(asset, asset_factory)
      @asset = asset
      @af = asset_factory
    end

    def name
      @asset.to_s
    end

    def children
      required = DirectiveReader.read_required(@asset)
      required.map { |r| dep_from_name(r) }
    end

  private
    def dep_from_name(name)
      AssetDependency.new(@af.from_name(name), @af)
    end
  end
end
