# Based on Apple Binary Property List serializer - http://gist.github.com/303378
require 'iconv'

module BinaryPlist
  
  # Very generic type for now
  MIME_TYPE = 'application/octet-stream'
  
  module Converter

    # Difference between Apple and UNIX timestamps
    DATE_EPOCH_OFFSET_APPLE_UNIX = 978307200

    # Text encoding
    INPUT_TEXT_ENCODING = 'UTF-8'
    PLIST_TEXT_ENCODING = 'UTF-16BE'
  
    # For marking strings as binary data which will be decoded as a CFData object
    CFData = Struct.new(:data)
  
    # Convert a Ruby data structure into an OS X binary property list file. (.plist)
    # Works as you'd expect. Integers are limited to 4 bytes, even though the format implies longer values can be written.
    # Strings are assumed to be in UTF-8 format. Symbols are written as strings.
    def self.convert(data)
      write("", data)
    end
  
    # Alternative interface which writes data to the out object using <<
    def self.write(out, data)
      # Find out how many objects there are, so we know how big the references are
      count = count_objects(data)
      ref_format, ref_size = int_format_and_size(count)
    
      # Now serialize all the objects
      values = Array.new
      append_values(data, values, ref_format)
    
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
      out << [0,0,offset_size,ref_size, 0,values.length, 0,0, 0,offset].pack("NnCCNNNNNN")
    
      out
    end
  
    private
  
      def self.count_objects(data)
        case data
        when Array
          data.inject(1) { |sum,x| sum + count_objects(x) }
        when Hash
          # Note: Assumes that the keys aren't a Hash or Array
          data.length + count_objects(data.values)
        else
          1
        end
      end
  
      def self.append_values(data, values, ref_format)
        case data

        # Constant values
        when nil
          # values << "\x00"
          # raise "Can't store a nil in a binary plist. While the format supports it, decoders don't like it."
          append_values("", values, ref_format)
        when false
          values << "\x08"
        when true
          values << "\x09"

        when Integer
          raise "Integer out of range to write in binary plist" if data < -2147483648 || data > 0x7FFFFFFF
          values << packed_int(data)

        when Float
          values << "\x23#{[data].pack("d").reverse}"

        when Symbol
          append_values(data.to_s, values, ref_format)

        when String
          if data =~ /[\x80-\xff]/
            # Has high bits set, so is UTF-8 and must be reencoded for the plist file
            c = Iconv.iconv(PLIST_TEXT_ENCODING, INPUT_TEXT_ENCODING, data).join
            values << "#{objhdr_with_length(0x60, c.length / 2)}#{c}"
          else
            # Just ASCII
            o = objhdr_with_length(0x50, data.length)
            o << data
            values << o
          end

        when CFData
          o = objhdr_with_length(0x40, data.data.length)
          o << data.data
          values << o

        when Time
          v = data.getutc.to_f - DATE_EPOCH_OFFSET_APPLE_UNIX
          values << "\x33#{[v].pack("d").reverse}"

        when Hash
          o = objhdr_with_length(0xd0, data.length)
          values << o # now, so we get the refs of other objects right
          ks = Array.new
          vs = Array.new
          data.each do |k,v|
            ks << values.length
            append_values(k, values, ref_format)
            vs << values.length
            append_values(v, values, ref_format)
          end
          o << ks.pack(ref_format)
          o << vs.pack(ref_format)

        when Array
          o = objhdr_with_length(0xa0, data.length)
          values << o # now, so we get the refs of other objects right
          refs = Array.new
          data.each do |e|
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
          ['N*',4]
        elsif i > 0xff
          ['n*',2]
        else
          ['C*',1]
        end
      end

      def self.packed_int(data)
        if data < 0
          # Need to use 64 bits for negative numbers.
          [0x13,0xffffffff,data].pack("CNN")
        elsif data > 0xffff
          [0x12,data].pack("CN")
        elsif data > 0xff
          [0x11,data].pack("Cn")
        else
          [0x10,data].pack("CC")
        end
      end
    
      def self.objhdr_with_length(id, length)
        if length < 0xf
          (id + length).chr
        else
          (id + 0xf).chr + packed_int(length)
        end
      end
  end
end
