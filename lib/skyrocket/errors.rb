module Skyrocket
  class AssetNotFoundError < Exception; end;
  class CircularReferenceError < Exception; end;
  class PathNotInAssetsError < Exception; end;
  class NoValidProcessorError < Exception; end;
end
