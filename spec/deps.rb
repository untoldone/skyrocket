$:.unshift File.expand_path("../lib", __FILE__)

require 'skyrocket'

def fixture_asset_manager
  fixture_path = File.expand_path(".", __FILE__) + "/fixture"
  Skyrocket::AssetManager.new({
    :base_url => '/blog',
    :lib_dirs => [fixture_path + "/assets/lib"],
    :asset_dirs => [fixture_path + "/assets/public"],
    :output_dir => fixture_path + "/public"
  })
end
