# encoding: UTF-8
require 'spec_helper'

describe BinaryPlist, 'encode' do
  it 'encodes nil as an empty string' do
    nil.to_plist.should == plist('nil')
  end
  
  it 'encodes false' do
    false.to_plist.should == plist('false')
  end
  
  it 'encodes true' do
    true.to_plist.should == plist('true')
  end
  
  it 'encodes an integer' do
    42.to_plist.should == plist('integer')
  end
  
  it 'encodes a large integer' do
    5414922050.to_plist.should == plist('large_integer')
  end
  
  it 'can\'t encode crazy large integers'
  
  it 'encodes a float' do
    3.14159265.to_plist.should == plist('float')
  end
  
  it 'encodes a string' do
    'Hello World'.to_plist.should == plist('string')
  end
  
  it 'encodes a symbol' do
    :'Hello World'.to_plist.should == plist('string')
  end
  
  it 'encodes a crazy string' do
    'This is ç®áz¥'.to_plist.should == plist('crazy_string')
  end
  
  it 'encodes some data' do
    data = BinaryPlist::Encoding::CFData.new
    data.data = ['62706c6973743030d401020304050876'].pack('H*')
    data.to_plist.should == plist('data')
  end
  
  it 'encodes a time' do
    Time.utc(2010, 3, 13, 12, 23, 42).to_plist == plist('time')
  end
  
  it 'encodes a datetime' do
    require 'date'
    DateTime.new(2010, 3, 13, 12, 23, 42).to_plist == plist('time')
  end
  
  it 'encodes a date' do
    require 'date'
    Date.new(2010, 7, 4).to_plist == plist('date')
  end
  
  it 'encodes a hash' do
    { 'name' => 'Sam', 'color' => 'blue' }.to_plist.should == plist('hash')
  end
  
  it 'encodes an array' do
    ['Oranges', 'Apples', 'Grapes'].to_plist.should == plist('array')
  end
  
  it 'can\'t encode unknown objects' do
    lambda { Object.new.to_plist }.should raise_error
  end
  
end
