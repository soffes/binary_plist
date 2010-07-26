Gem::Specification.new do |s|
  s.name        = "binary_plist"
  s.version     = "0.0.3"
  s.author      = "Sam Soffes"
  s.email       = "sam@samsoff.es"
  s.homepage    = "http://github.com/samsoffes/binary_plist"
  s.summary     = "Easily convert Ruby objects to the Apple Binary Plist format."
  s.description = "Easily convert Ruby objects to the Apple Binary Plist format for transferring data to Objective-C applications."
  s.platform    = Gem::Platform::RUBY
  
  s.files        = Dir["{lib}/**/*", "[A-Z]*", "init.rb"]
  s.require_path = "lib"
  
  s.add_dependency("activesupport", "~> 2.0")
  s.add_development_dependency("rspec", "1.3.0")
end
