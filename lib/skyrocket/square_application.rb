module Skyrocket
  class SquareApplication
    def initialize(assets)
      @assets = assets
    end

    def call(env)
      path_info = env["PATH_INFO"]
      if(@assets[path_info])
        [200, {}, @assets[path_info]]
      else
        [404, {}, '']
      end
    end
  end
end