$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ric_customer/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ric_customer"
  s.version     = RicCustomer::VERSION
  s.authors     = ["Matej Outly (Clockstar s.r.o.)"]
  s.email       = ["matej@clockstar.cz"]
  s.homepage    = ""
  s.summary     = "RIC engine for customer database"
  s.description = "Evidence of customers with search and statistics."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.1"

end
