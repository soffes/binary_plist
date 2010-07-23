Gem::Specification.new do |s|
  s.name        = "binary_plist"
  s.version     = "0.0.1"
  s.author      = "Sam Soffes"
  s.email       = "sam@samsoff.es"
  s.homepage    = "http://github.com/samsoffes/binary_plist"
  s.summary     = "Easily add the Apple Binary Plist format to your controllers."
  s.description = "Easily add the Apple Binary Plist format to your controllers for transferring data to Objective-C applications."
  s.platform    = Gem::Platform::RUBY
  
  s.files        = Dir["{lib}/**/*", "[A-Z]*", "init.rb"]
  s.require_path = "lib"
  
  s.add_dependency("activesupport", "~> 3.0")
end
