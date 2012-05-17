module Skyrocket
  class RelativeResolver
    def initialize(file, asset_manager)
      @file = file
      @am = asset_manager
    end

    # order:
    # same dir relative
    # asset dirs in order
    # lib dirs in order

    # matches to something.html.erb:
    # something
    # something.html
    # something.html.erb

    def resolve_path(path)

    end
  end
end