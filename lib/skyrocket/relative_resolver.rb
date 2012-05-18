module Skyrocket
  class RelativeResolver
    def initialize(asset_manager)
      @file = file
      @am = asset_manager
    end

    def asset_name_variations(filename)
      [filename, 
       filename.chomp(File.extname(filename)),
       filename.sub(/\..*$/, '')]
    end

    # order:
    # same dir relative
    # asset dirs in order
    # lib dirs in order

    # matches to something.html.erb:
    # something
    # something.html
    # something.html.erb

    def resolve_path(path, relative_asset = nil)
      
    end
  end
end