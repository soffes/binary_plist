# TODO: Make supported classes a constant and define CFData

[NilClass, FalseClass, TrueClass, Integer, Float, Symbol, String, Time, Hash, Array].each do |klass|
  klass.class_eval <<-RUBY, __FILE__, __LINE__
    def to_plist(options = nil)
      BinaryPlist.encode(self, options)
    end
  RUBY
end
