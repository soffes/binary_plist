require 'mongoid'
require 'spec_helper'

describe BinaryPlist, 'encode with Mongoid support' do

  it 'adds support for BSON::ObjectId to SUPPORTED_CLASSES' do
    BinaryPlist::Encoding::SUPPORTED_CLASSES.should include(BSON::ObjectId)
  end

  it 'encodes a Mongoid Object ID' do
    bson_id = BSON::ObjectId.from_string('4da3788a9ed6120d65000004')
    bson_id.to_plist.should == plist('bson_objectid')
  end

end
