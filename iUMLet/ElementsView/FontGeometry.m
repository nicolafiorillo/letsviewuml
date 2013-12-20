//
//  FontGeometry.m
//  Let's view UML
//
//  Created by Nicola Fiorillo on 19/12/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import "FontGeometry.h"

static NSString * const kElementViewFontName			= @"LucidaGrande";
static NSString * const kElementViewFontNameBold		= @"LucidaGrande-Bold";
#warning TODO: move to LucidaGrande for italic
static NSString * const kElementViewFontNameItalic		= @"TrebuchetMS-Italic";
static NSString * const kElementViewFontNameBoldItalic	= @"Trebuchet-BoldItalic";

static CGFloat const kElementViewFontSize				= 14.0f;
static CGFloat const kElementViewFontUpperSpace			= 2.0f;
static CGFloat const kElementViewFontFromBottomSpace	= 6.0f;
static CGFloat const kElementViewFontSeparatorSpace		= 3.0f;
static CGFloat const kElementViewFontLeftSpace			= 8.0f;
static CGFloat const kElementViewUnderscoreSpace		= 0.7f;

@implementation FontGeometry

- (id)initWithZoom:(NSInteger)zoom
{
	self = [super init];
	
	CGFloat scaleFactor = zoom / 10;
	
	if (self)
	{
		self.fontSize = kElementViewFontSize * scaleFactor;
		self.fontUpperSpace = kElementViewFontUpperSpace * scaleFactor;
		self.fontFromBottomSpace = kElementViewFontFromBottomSpace * scaleFactor;
		self.fontSeparatorSpace = kElementViewFontSeparatorSpace * scaleFactor;
		self.fontLeftSpace = kElementViewFontLeftSpace * scaleFactor;
		self.underscoreSpace = kElementViewUnderscoreSpace * scaleFactor;
		
		self.font = [UIFont fontWithName:kElementViewFontName size:self.fontSize];
		self.fontBold = [UIFont fontWithName:kElementViewFontNameBold size:self.fontSize];
		self.fontItalic = [UIFont fontWithName:kElementViewFontNameItalic size:self.fontSize];
		self.fontBoldItalic = [UIFont fontWithName:kElementViewFontNameBoldItalic size:self.fontSize];
	}
	
	return self;
}

@end
