require 'skyrocket/version'

module Skyrocket
  autoload :Asset,                 "skyrocket/asset"
  autoload :AssetFactory,          "skyrocket/asset_factory"
  autoload :AssetManager,          "skyrocket/asset_manager"
  autoload :CoffeescriptProcessor, "skyrocket/coffeescript_processor"
  autoload :ErbProcessor,          "skyrocket/erb_processor"
  autoload :LessProcessor,         "skyrocket/less_processor"
  autoload :Processor,             "skyrocket/processor"

  autoload :PathNotInAssetsError,  "skyrocket/errors"
end
