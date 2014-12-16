$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ric_advert/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ric_advert"
  s.version     = RicAdvert::VERSION
  s.authors     = ["Matej Outly (Clockstar s.r.o.)"]
  s.email       = ["matej@clockstar.cz"]
  s.homepage    = ""
  s.summary     = "RIC engine for on-site advertising"
  s.description = "Banners and statistics with administration and interface for observation."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.1"
  s.add_dependency "paperclip", "~> 4.1"

end
