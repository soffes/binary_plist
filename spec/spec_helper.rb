require "rubygems"
require "spec"
require "binary_plist"

def encode object
  BinaryPlist.encode object
end

def plist name
  File.open(File.dirname(__FILE__) + "/plist/#{name}.plist").read
end
