require "spec_helper"

describe BinaryPlist, "encode" do
  it "encodes nil as an empty string" do
    nil.to_plist.should == plist("nil")
  end
  
  it "encodes false" do
    false.to_plist.should == plist("false")
  end
  
  it "encodes true" do
    true.to_plist.should == plist("true")
  end
  
  it "encodes an integer" do
    42.to_plist.should == plist("integer")
  end
  
  it "encodes a large integer"
  
  it "can't encode crazy large integers"
  
  it "encodes a float" do
    3.14159265.to_plist.should == plist("float")
  end
  
  it "encodes a symbol" do
    :"Hello World".to_plist.should == plist("string")
  end
  
  it "encodes a string" do
    "Hello World".to_plist.should == plist("string")
  end
  
  it "encodes a crazy string" do
    "This is ç®áz¥".to_plist.should == plist("crazy_string")
  end
  
  it "encodes some data"
  
  it "encodes a time"
  
  it "encodes a date"
  
  it "encodes a datetime"
  
  it "encodes a hash" do
    { "name" => "Sam", "color" => "blue" }.to_plist.should == plist("hash")
  end
  
  it "encodes an array" do
    ["Oranges", "Apples", "Grapes"].to_plist.should == plist("array")
  end
  
  it "can't encode unknown objects" do
    lambda { Object.new.to_plist }.should raise_error
  end
  
end
