//
//  TextLine.m
//  Let's view UML
//
//  Created by Nicola Fiorillo on 6/27/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import "TextLine.h"
#import "NSString+NSStringLib.h"

@interface TextLine()

@property (strong, nonatomic, readwrite)NSString * text;
@property (nonatomic, readwrite)CGSize textSize;
@property (nonatomic, readwrite)BOOL isSeparator;
@property (nonatomic, readwrite)BOOL isDashedSeparator;
@property (nonatomic, readwrite)FontStyle fontStyle;

@property (nonatomic, readwrite)BOOL hasLeftArrow;
@property (nonatomic, readwrite)BOOL hasRightArrow;

@end

@implementation TextLine

- (id)init
{
	self = [super init];
	if (self)
		[self commonInit];

	return self;
}

- (void)commonInit
{
	self.text = @"";
	self.hasLeftArrow = self.hasRightArrow	= NO;
	self.isDashedSeparator = self.isSeparator = NO;
}

+ (TextLine *)separator
{
	TextLine * sep = [TextLine new];
	sep.isSeparator = YES;
	sep.text = @"--";

	return sep;
}

+ (TextLine *)dashedSeparator
{
	TextLine * sep = [TextLine new];
	sep.isDashedSeparator = YES;
	sep.text = @"-.";

	return sep;
}

+ (TextLine *)text:(NSString *)text inRect:(CGSize)size withFont:(UIFont *)font andStyle:(FontStyle)fontStyle
{
	TextLine * t = [[TextLine alloc] init];

	t.text = [NSString stringWithString:text];

	t.isSeparator = NO;
	t.fontStyle = fontStyle;

	if ([t.text beginWithString:@"<"] && ![t.text beginWithString:@"<<"])
	{
		NSRange beginRange = NSMakeRange(0, 1);
		t.text = [t.text stringByReplacingCharactersInRange:beginRange withString:@""];
		t.hasLeftArrow = YES;
	}
	
	if ([t.text endWithString:@">"] && ![t.text endWithString:@">>"])
	{
		NSRange endRange = NSMakeRange(t.text.length - 1, 1);
		t.text = [t.text stringByReplacingCharactersInRange:endRange withString:@""];
		t.hasRightArrow = YES;
	}

	NSString * realtext = [NSString stringWithCString:[t printable] encoding:NSISOLatin1StringEncoding];
	t.textSize = [realtext sizeWithFont:font constrainedToSize:size lineBreakMode:0];
    
//	t.textSize = [realtext boundingRectWithSize:size options:0 attributes:nil context:nil].size;

	return t;
}

- (const char *)printable
{
	return [self.text replaceAngulars];
}

@end
