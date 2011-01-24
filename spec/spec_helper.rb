require "rubygems"
require "rspec"
require "binary_plist"

# Loads a plist file from the spec directory
# These were created using Apple's Property List Editor
def plist name
  File.open(File.dirname(__FILE__) + "/plist/#{name}.plist").read
end
