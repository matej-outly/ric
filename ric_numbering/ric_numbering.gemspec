$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
version = File.read(File.expand_path('../../RIC_VERSION', __FILE__)).strip

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ric_numbering"
  s.version     = version
  s.authors     = ["Matej Outly (Clockstar s.r.o.)"]
  s.email       = ["matej@clockstar.cz"]
  s.homepage    = "http://www.clockstar.cz"
  s.summary     = "RIC engine managing number sequences"
  s.description = "Different subjects in the system can be numbered with automaticaly increased sequence number. Number sequence can be scoped."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2"
end
