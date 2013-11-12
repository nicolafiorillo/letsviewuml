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
@property (nonatomic, strong)NSDictionary * attributesDictionaryTitle;

@end

@implementation GenericItemCollectionViewCell

CGFloat const kGenericItemCollectionViewCellSeparatorDistance		= 30.0f;
CGFloat const kGenericItemCollectionViewCellTitleDistance			= 20.0f;
CGFloat const kGenericItemCollectionViewCellLineWidth				= 1.0f;
CGFloat const kGenericItemCollectionViewCellLeftSpace				= 10.0f;

static NSString * const kGenericItemCollectionViewCellFontName		= @"TrebuchetMS";
static CGFloat const kGenericItemCollectionViewCellFontSize         = 15.0f;

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
        
        CGAffineTransform matrix = CGAffineTransformMakeScale(1.0, -1.0);
        
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)kGenericItemCollectionViewCellFontName, 15, &matrix);
        self.attributesDictionaryTitle = [NSDictionary dictionaryWithObjectsAndKeys:(id)CFBridgingRelease(fontRef), (NSString*)kCTFontAttributeName, nil];
	}

	return self;
}

- (void)setName:(NSString *)name
{
	_name = name;
    self.textSize = [name sizeWithAttributes:@{NSFontAttributeName:self.font}];
}

- (void)drawName:(CGContextRef)context position:(GICVC_TextPosition)position
{
	CGFloat x = position == GICVC_TextPositionCenter ? (CGRectGetWidth(self.bounds) - self.textSize.width) / 2 : kGenericItemCollectionViewCellLeftSpace;
	if (x <= 0)
		x = kGenericItemCollectionViewCellLeftSpace;

	CGContextSaveGState(context);

	CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    
    NSAttributedString * attrString = [[NSAttributedString alloc]initWithString:self.name attributes:self.attributesDictionaryTitle];
    CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)attrString);

	CGContextSetTextDrawingMode(context, kCGTextFill);
	CGContextSetShouldAntialias(context, true);

	CGContextSetTextPosition(context, x, kGenericItemCollectionViewCellTitleDistance);
    CTLineDraw(line, context);
    CFRelease(line);
    
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
