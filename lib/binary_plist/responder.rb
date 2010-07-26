module BinaryPlist
  module BinaryPlistResponder
    def to_format
      BinaryPlist.encode resource
    end
  end
end
