require 'skyrocket/version'

module Skyrocket
  autoload :Asset,                 "skyrocket/asset"
  autoload :AssetDependency,       "skyrocket/asset_dependency"
  autoload :AssetLocator,          "skyrocket/asset_locator"
  autoload :AssetFactory,          "skyrocket/asset_factory"
  autoload :AssetManager,          "skyrocket/asset_manager"
  autoload :AssetWriter,           "skyrocket/asset_writer"
  autoload :CoffeescriptProcessor, "skyrocket/coffeescript_processor"
  autoload :DependencySearcher,    "skyrocket/dependency_searcher"
  autoload :DirectiveProcessor,    "skyrocket/directive_processor"
  autoload :DirectiveReader,       "skyrocket/directive_reader"
  autoload :EmptyProcessor,        "skyrocket/empty_processor"
  autoload :ErbProcessor,          "skyrocket/erb_processor"
  autoload :JavascriptProcessor,   "skyrocket/javascript_processor"
  autoload :LessProcessor,         "skyrocket/less_processor"
  autoload :Processor,             "skyrocket/processor"
  autoload :ProcessorFactory,      "skyrocket/processor_factory"

  autoload :AssetNotFoundError,    "skyrocket/errors"
  autoload :CircularReferenceError, "skyrocket/errors"
  autoload :NoValidProcessorError, "skyrocket/errors"
  autoload :PathNotInAssetsError,  "skyrocket/errors"
end
