# BinaryPlist

Rails plugin for easily adding a binary plist format. The binary plist format is ideal for transferring data to an Objective-C based application.

**Note:** This is still a work in progress. It should be ready to use for most applications. The most noticeable issue is the lack of support for large integers.

## Installation

Add the following line to your bundle and run `bundle install`.

    gem "binary_plist"

## Usage

All you have to do is add the `plist` format to your `respond_to` block:

    def index
      @posts = Post.all
      respond_to do |format|
        format.html
        format.plist { render :plist => @posts }
      end
    end

You can do the combined style if you're support multiple formats like `json` or `xml`.

    def index
      @posts = Post.all
      respond_to do |format|
        format.html
        format.any(:json, :plist) { render request.format.to_sym => @posts }
      end
    end

## Consuming

On the Objective-C side, it's ridiculously easy to consume the plist data.

    NSURL *url = [NSURL URLWithString:@"http://localhost:3000/posts.plist"];
    NSArray *posts = [NSArray arrayWithContentsOfURL:url];

You can also use the more flexible syntax:

    NSURL *url = [NSURL URLWithString:@"http://localhost:3000/posts.plist"];
    NSDate *date = [NSData dataWithContentsOfURL:url];
    id result = [NSPropertyListSerialization propertyListFromData:data
			     mutabilityOption:NSPropertyListImmutable format:NULL errorDescription:nil];
	
	if ([result isKindOfClass:[NSArray class]]) {
	    // Handle array response
	} else if ([result isKindOfClass:[NSDictionary class]]) {
	    // Handle dictionary response
	} else {
	    // Etc...
	}

Copyright (c) 2010 Sam Soffes, released under the MIT license
