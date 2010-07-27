BinaryPlist::Encoding::SUPPORTED_CLASSES.each do |klass|
  klass.class_eval <<-RUBY, __FILE__, __LINE__
    def to_plist(options = nil)
      BinaryPlist.encode(self, options)
    end
  RUBY
end
