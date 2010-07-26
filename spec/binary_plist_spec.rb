require "spec_helper"

describe BinaryPlist, "encode" do
  it "encodes nil as an empty string" do
    encode(nil).should == plist("nil")
  end
  
  it "encodes false" do
    encode(false).should == plist("false")
  end
  
  it "encodes true" do
    encode(true).should == plist("true")
  end
  
  it "encodes an integer" do
    encode(42).should == plist("integer")
  end
  
  it "encodes a large integer"
  
  it "encodes a float" do
    encode(3.14159265).should == plist("float")
  end
  
  it "encodes a symbol" do
    encode(:"Hello World").should == plist("string")
  end
  
  it "encodes a string" do
    encode("Hello World").should == plist("string")
  end
  
  it "encodes a crazy string" do
    encode("This is ç®áz¥").should == plist("crazy_string")
  end
  
  it "encodes some data"
  
  it "encodes a time"
  
  it "encodes a date"
  
  it "encodes a datetime"
  
  it "encodes a hash" do
    encode(["name" => "Sam Soffes", "website" => "http://samsoff.es"]).should == plist("hash")
  end
  
  it "encodes an array" do
    encode(["Oranges", "Apples", "Grapes"]).should == plist("array")
  end
  
  it "can't encode unknown objects" do
    lambda { encode(Object.new) }.should raise_error
  end
  
end
