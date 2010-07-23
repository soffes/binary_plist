# BinaryPlist

Rails plugin for easily adding a binary plist format. The binary plist format is ideal for transferring data to an Objective-C based application.

## Installation

Add the following line to your bundle and run `bundle install`.

    gem "binary_plist"

## Usage

All you have to do is add the `bplist` format to your `respond_to` block:

    def index
      @posts = Post.all
      respond_to do |format|
        format.html
        format.bplist { render :bplist => @posts }
      end
    end

You can do the combined style if you're support multiple formats like `json` or `xml`.

    def index
      @posts = Post.all
      respond_to do |format|
        format.html
        format.any(:json, :bplist) { render request.format.to_sym => @posts }
      end
    end

## Consuming

On the Objective-C side, it's ridiculously easy to consume the plist data.

    NSURL *url = [NSURL URLWithString:@"http://localhost:3000/posts.bplist"];
    NSArray *posts = [NSArray arrayWithContentsOfURL:url];

You can also use the more flexible syntax:

    NSURL *url = [NSURL URLWithString:@"http://localhost:3000/posts.bplist"];
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
