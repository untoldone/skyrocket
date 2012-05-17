module Skyrocket
  class AssetApplication
    def initialize(assets)
      @assets = assets
    end

    def call(env)
      path_info = env["PATH_INFO"]
      if(@assets.asset_by_path(path_info))
        [200, {}, @assets.asset_by_path(path_info)]
      else
        [404, {}, '']
      end
    end
  end
end