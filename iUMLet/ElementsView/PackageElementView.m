//
//  PackageElementView.m
//  Let's view UML
//
//  Created by Nicola Fiorillo on 7/5/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import "PackageElementView.h"
#import "TextLine.h"
#import <QuartzCore/QuartzCore.h>

@interface PackageElementView()

@property (strong, nonatomic)NSMutableArray * headerLines;
@property (nonatomic)CGRect headerRect;
@property (strong, nonatomic)NSMutableArray * bodyLines;
@property (nonatomic)CGRect bodyRect;
@property (nonatomic)CGRect bodyTextRect;

@property (nonatomic)CGFloat headerMinHeight;
@property (nonatomic)CGFloat headerLeftSpace;
@property (nonatomic)CGFloat headerRightSpace;
@property (nonatomic)CGFloat headerUpperSpace;
@property (nonatomic)CGFloat headerBottomSpace;
@property (nonatomic)CGFloat bodyBottomSpace;

@end

@implementation PackageElementView

+(Class)layerClass
{
	return [CATiledLayer class];
}

static CGFloat const kPackageElementHeaderMinHeight		= 20.0f;
static CGFloat const kPackageElementHeaderLeftSpace		= 7.0f;
static CGFloat const kPackageElementHeaderRightSpace		= 11.0f;
static CGFloat const kPackageElementHeaderUpperSpace		= 2.4f;
static CGFloat const kPackageElementHeaderBottomSpace	= 4.7f;
static CGFloat const kPackageElementBodyBottomSpace		= 2.4f;

- (id)initWithElement:(Element *)element andZoom:(NSInteger)zoom
{
	self = [super initWithElement:element andZoom:zoom];

	if (self)
	{
		self.headerMinHeight = kPackageElementHeaderMinHeight * self.scaleFactor;
		self.headerLeftSpace = kPackageElementHeaderLeftSpace * self.scaleFactor;
		self.headerRightSpace = kPackageElementHeaderRightSpace * self.scaleFactor;
		self.headerUpperSpace = kPackageElementHeaderUpperSpace * self.scaleFactor;
		self.headerBottomSpace = kPackageElementHeaderBottomSpace * self.scaleFactor;
		self.bodyBottomSpace = kPackageElementBodyBottomSpace * self.scaleFactor;

		[self prepareHeader];
		[self prepareBody];
	}

	return self;
}

- (void)prepareHeader
{
	CGFloat minWidth = (CGRectGetWidth(self.boundingRect) / 10) * 4;

	CGFloat currentWidth = minWidth;

	int yOffset = 0;

	self.headerLines = [[NSMutableArray alloc] init];
	for (TextLine * textLine in self.text)
	{
		if (textLine.isSeparator)
			break;

		[self.headerLines addObject:textLine];

		float y = self.fontSize + self.headerUpperSpace;

		currentWidth = MAX(currentWidth, textLine.textSize.width + self.headerRightSpace);

		y += yOffset;
		yOffset = y;

		textLine.textPosition = CGPointMake(self.headerLeftSpace, y);
	}

	if (yOffset == 0)
		yOffset = self.headerMinHeight;

	self.headerRect = CGRectMake(CGRectGetMinX(self.boundingRect), CGRectGetMinY(self.boundingRect), currentWidth, yOffset + self.headerBottomSpace);

	self.bodyRect = CGRectMake(CGRectGetMinX(self.boundingRect), CGRectGetMinY(self.boundingRect) + CGRectGetHeight(self.headerRect), CGRectGetWidth(self.boundingRect), CGRectGetHeight(self.boundingRect) - CGRectGetHeight(self.headerRect));
}

- (void)drawHeader:(CGContextRef)context
{
	CGContextFillRect(context, self.headerRect);

	CGMutablePathRef path = CGPathCreateMutable();

	CGPathMoveToPoint(path, NULL, CGRectGetMinX(self.boundingRect), CGRectGetMinY(self.boundingRect) + CGRectGetHeight(self.headerRect));
	CGPathAddLineToPoint(path, NULL, CGRectGetMinX(self.boundingRect), CGRectGetMinY(self.boundingRect));
	CGPathAddLineToPoint(path, NULL, CGRectGetMinX(self.boundingRect) + CGRectGetWidth(self.headerRect), CGRectGetMinY(self.boundingRect));
	CGPathAddLineToPoint(path, NULL, CGRectGetMinX(self.boundingRect) + CGRectGetWidth(self.headerRect), CGRectGetMinY(self.boundingRect) + CGRectGetHeight(self.headerRect));

	CGContextAddPath(context, path);
	CGContextDrawPath(context, kCGPathStroke);

	CGPathRelease(path);

	CGContextSetFillColorWithColor(context, [self.foregroundColor CGColor]);

	for (TextLine * textLine in self.headerLines)
		[self drawText:textLine inContext:context atX:textLine.textPosition.x atY:textLine.textPosition.y];
}

- (void)prepareBody
{
	self.bodyLines = [[NSMutableArray alloc] init];
	BOOL separatorFound = NO;

	CGFloat totalHeight = 0;
	
	for (TextLine * textLine in self.text)
	{
		if (textLine.isSeparator)
		{
			separatorFound = YES;
			continue;
		}
		else
		{
			if (separatorFound)
			{
				[self.bodyLines addObject:textLine];
				totalHeight += self.fontSize;// textLine.textSize.height;
			}
		}
	}

	CGFloat h = (CGRectGetHeight(self.bodyRect) - totalHeight) / 2;
	self.bodyTextRect = CGRectInset(self.bodyRect, 0, h);
}

- (void)drawBody:(CGContextRef)context
{
	CGContextSetFillColorWithColor(context, [self.backgroundColor CGColor]);

	CGContextFillRect(context, self.bodyRect);
	CGContextStrokeRect(context, self.bodyRect);

	if (self.bodyLines.count > 0)
	{
		CGFloat yOffset = CGRectGetHeight(self.bodyTextRect) / self.bodyLines.count;
		CGFloat y = CGRectGetMinY(self.bodyTextRect) + yOffset - self.bodyBottomSpace;
		for (TextLine * textLine in self.bodyLines)
		{
			float x = (CGRectGetWidth(self.bodyRect) - textLine.textSize.width) / 2;

			[self drawText:textLine inContext:context atX:x atY:y];
			y += yOffset;
		}
	}
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)context
{
	CGContextSaveGState(context);

	CGContextSetStrokeColorWithColor(context, [self.foregroundColor CGColor]);
	CGContextSetFillColorWithColor(context, [self.backgroundColor CGColor]);

	CGContextSetLineWidth(context, 0.8);

	[self drawHeader:context];
	[self drawBody:context];

	CGContextRestoreGState(context);
}

@end
