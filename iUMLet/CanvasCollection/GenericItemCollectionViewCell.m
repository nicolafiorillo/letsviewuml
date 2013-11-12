//
//  GenericItemCollectionViewCell.m
//  Let's view UML
//
//  Created by Nicola Fiorillo on 8/4/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import "GenericItemCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>

@interface GenericItemCollectionViewCell()

@property (nonatomic)CGRect previewRect;
@property (nonatomic)CGSize textSize;
@property (nonatomic, strong)UIImage * noPreviewImage;

@end

@implementation GenericItemCollectionViewCell

CGFloat const kGenericItemCollectionViewCellSeparatorDistance		= 30.0f;
CGFloat const kGenericItemCollectionViewCellTitleDistance			= 20.0f;
CGFloat const kGenericItemCollectionViewCellLineWidth				= 1.0f;
CGFloat const kGenericItemCollectionViewCellLeftSpace				= 10.0f;

static NSString * const kGenericItemCollectionViewCellFontName		= @"TrebuchetMS";
static CGFloat const kGenericItemCollectionViewCellFontSize		= 15.0f;

- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super initWithCoder:decoder];
	if (self)
	{
		self.layer.masksToBounds = NO;
		self.layer.shadowColor = [UIColor blackColor].CGColor;
		self.layer.shadowRadius = 3.0f;
		self.layer.shadowOffset = CGSizeMake(2.0f, 3.0f);
		self.layer.shadowOpacity = 0.5f;

		self.font = [UIFont fontWithName:kGenericItemCollectionViewCellFontName size:kGenericItemCollectionViewCellFontSize];

		self.previewRect = CGRectMake(1, -kGenericItemCollectionViewCellSeparatorDistance, CGRectGetWidth(self.bounds) - 2, CGRectGetHeight(self.bounds) - kGenericItemCollectionViewCellSeparatorDistance - 1);

		self.noPreviewImage = [UIImage imageNamed:@"NoPreview"];
	}

	return self;
}

- (void)setName:(NSString *)name
{
	_name = name;
	self.textSize = [name sizeWithFont:self.font constrainedToSize:self.bounds.size lineBreakMode:0];
}

- (void)drawName:(CGContextRef)context position:(GICVC_TextPosition)position
{
	CGFloat x = position == GICVC_TextPositionCenter ? (CGRectGetWidth(self.bounds) - self.textSize.width) / 2 : kGenericItemCollectionViewCellLeftSpace;
	if (x <= 0)
		x = kGenericItemCollectionViewCellLeftSpace;

	CGContextSaveGState(context);

	CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);

	CGContextSelectFont(context, [kGenericItemCollectionViewCellFontName UTF8String], 15.0, kCGEncodingMacRoman);
	CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1.0, -1.0));
	CGContextSetTextDrawingMode(context, kCGTextFill);
	CGContextSetShouldAntialias(context, true);

	const char * label = [self.name UTF8String];
	CGContextShowTextAtPoint(context, x, kGenericItemCollectionViewCellTitleDistance, label, strlen(label));

	CGContextRestoreGState(context);
}

- (void)drawPreview:(CGContextRef)context
{
	CGImageRef imageRef = [self.preview CGImage];
	if (!imageRef)
		imageRef = [self.noPreviewImage CGImage];

	CGContextSaveGState(context);

	CGContextTranslateCTM(context, 0, CGRectGetHeight(self.previewRect));
	CGContextScaleCTM(context, 1.0f, -1.0f);

	CGContextDrawImage(context, self.previewRect, imageRef);

	CGContextRestoreGState(context);
}

@end
