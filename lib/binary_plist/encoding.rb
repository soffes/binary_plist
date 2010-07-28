require "iconv"
require "date"

module BinaryPlist
  
  def self.encode value, options = nil
    Encoding.encode value
  end

  module Encoding
    # For marking strings as binary data which will be decoded as a CFData object
    CFData = Struct.new(:data)
    
    SUPPORTED_CLASSES = [NilClass, FalseClass, TrueClass, Integer, Float, Symbol, String, CFData, Time, Date, DateTime, Hash, Array]
    
    # Difference between Apple and UNIX timestamps
    DATE_EPOCH_OFFSET_APPLE_UNIX = 978307200

    # Text encoding
    INPUT_TEXT_ENCODING = 'UTF-8'
    PLIST_TEXT_ENCODING = 'UTF-16BE'
    
    # Convert a Ruby data structure into a binary property list file.
    # Works as you'd expect. Integers are limited to 4 bytes, even though the format implies longer values can be written.
    # Strings are assumed to be in UTF-8 format. Symbols are written as strings.
    def self.encode object
      write "", object
    end

    # Alternative interface which writes data to the out object using <<
    def self.write out, object
      # Find out how many objects there are, so we know how big the references are
      count = count_objects(object)
      ref_format, ref_size = int_format_and_size(count)

      # Now serialize all the objects
      values = Array.new
      append_values(object, values, ref_format)

      # Write header, then the values, calculating offsets as they're written
      out << 'bplist00'
      offset = 8
      offsets = Array.new
      values.each do |v|
        offsets << offset
        out << v
        offset += v.length
      end

      # How big should the offset ints be?
      # Decoder gets upset if the size can't fit the entire file, even if it's not strictly needed, so add the length of the last value.
      offset_format, offset_size = int_format_and_size(offsets.last + values.last.length)

      # Write the offsets
      out << offsets.pack(offset_format)

      # Write trailer
      out << [0, 0, offset_size, ref_size, 0, values.length, 0, 0, 0, offset].pack("NnCCNNNNNN")
    end

    private

      def self.count_objects object
        case object
          when Array
            object.inject(1) { |sum, x| sum + count_objects(x) }

          when Hash
            # Note: Assumes that the keys aren't a Hash or Array
            object.length + count_objects(object.values)
          else
            1
        end
      end

      def self.append_values object, values, ref_format
        case object
          when nil
          # raise "Can't store a nil in a binary plist. While the format supports it, decoders don't like it." # values << "\x00"
          # Instead of storing actual nil, store an empty string
          append_values("", values, ref_format)

          when false
            values << "\x08"

          when true
            values << "\x09"

          when Integer
            raise "Integer out of range to write in binary plist: #{object}" if object < -2147483648 || object > 0x7FFFFFFF
            values << packed_int(object)

          when Float
            values << "\x23#{[object].pack("d").reverse}"

          when Symbol
            append_values(object.to_s, values, ref_format)

          when String
            if object =~ /[\x80-\xff]/
              # Has high bits set, so is UTF-8 and must be reencoded for the plist file
              c = Iconv.iconv(PLIST_TEXT_ENCODING, INPUT_TEXT_ENCODING, object).join
              values << objhdr_with_length(0x60, c.length / 2) + c
            else
              # Just ASCII
              values << objhdr_with_length(0x50, object.length) + object
            end

          when CFData
            o = objhdr_with_length(0x40, object.data.length)
            o << object.data
            values << o

          when Time
            v = object.getutc.to_f - DATE_EPOCH_OFFSET_APPLE_UNIX
            values << "\x33#{[v].pack("d").reverse}"
            
          when Date
            time = Time.utc(object.year, object.month, object.day, 0, 0, 0)
            append_values(time, values, ref_format)
            
          when DateTime
            time = Time.utc(object.year, object.month, object.day, object.hour, object.min, object.sec)
            append_values(time, values, ref_format)

          when Hash
            o = objhdr_with_length(0xd0, object.length)
            values << o # now, so we get the refs of other objects right
            ks = Array.new
            vs = Array.new
            object.each do |k,v|
              ks << values.length
              append_values(k, values, ref_format)
              vs << values.length
              append_values(v, values, ref_format)
            end
            o << ks.pack(ref_format)
            o << vs.pack(ref_format)


          when Array
            o = objhdr_with_length(0xa0, object.length)
            values << o # now, so we get the refs of other objects right
            refs = Array.new
            object.each do |e|
              refs << values.length # index in array of object we're about to write
              append_values(e, values, ref_format)
            end
            o << refs.pack(ref_format)

          else
            raise "Couldn't serialize value of class #{data.class.name}"
        end
      end

      def self.int_format_and_size(i)
        if i > 0xffff
          ['N*', 4]
        elsif i > 0xff
          ['n*', 2]
        else
          ['C*', 1]
        end
      end

      def self.packed_int integer
        if integer < 0
          # Need to use 64 bits for negative numbers.
          [0x13, 0xffffffff, integer].pack("CNN")
        elsif integer > 0xffff
          [0x12, integer].pack("CN")
        elsif integer > 0xff
          [0x11, integer].pack("Cn")
        else
          [0x10, integer].pack("CC")
        end
      end

      def self.objhdr_with_length id, length
        if length < 0xf
          (id + length).chr
        else
          (id + 0xf).chr + packed_int(length)
        end
      end
  end
end
