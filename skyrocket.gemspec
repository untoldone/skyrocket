$:.unshift File.expand_path("../lib", __FILE__)
require "skyrocket/version"

Gem::Specification.new do |s|
  s.name = "skyrocket"
  s.version = Skyrocket::VERSION
  s.summary = "Yet another opinionated static content/ web asset generation system"
  s.description = "An alternative and opinionated static content/ asset management tool that will concatenate/ render javascript, coffeescript, css, less, erb and html"

  s.files = Dir["README.md", "LICENSE", "lib/**/*.rb"]
  s.executables = ["skyrocket"]

  s.add_dependency "therubyracer"
  s.add_dependency "less"
  s.add_dependency "coffee-script"

  s.add_development_dependency "rack-test"
  s.add_development_dependency "rspec", "~> 2.0"
  s.add_development_dependency "rake"

  s.authors = ["Michael Wasser"]
  s.email = ["michael@raveld.com"]
  s.homepage = "http://www.raveld.com/"
end
