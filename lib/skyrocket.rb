require 'skyrocket/version'

module Skyrocket
  autoload :Processor,             "skyrocket/processor"
  autoload :CoffeescriptProcessor, "skyrocket/coffeescript_processor"
  autoload :LessProcessor,         "skyrocket/less_processor"
  autoload :ErbProcessor,          "skyrocket/erb_processor"
  autoload :AssetManager,          "skyrocket/asset_manager"
  autoload :Asset,                 "skyrocket/asset"
end