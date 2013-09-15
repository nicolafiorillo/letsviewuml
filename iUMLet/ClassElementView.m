//
//  ClassElementView.m
//  Let's view UML
//
//  Created by Nicola Fiorillo on 6/21/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import "ClassElementView.h"
#import <QuartzCore/QuartzCore.h>

static CGFloat const kClassElementActiveSpace = 8.0f;

@interface ClassElementView()

@property (nonatomic)CGFloat activeSpace;

@end

@implementation ClassElementView

+(Class)layerClass
{
	return [CATiledLayer class];
}

- (id)initWithElement:(Element *)element andZoom:(NSInteger)zoom
{
	self = [super initWithElement:element andZoom:zoom];

	if (self)
	{
		self.activeSpace = kClassElementActiveSpace * self.scaleFactor;
	}

	return self;
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)context
{
	CGContextSaveGState(context);

	CGContextSetShouldAntialias(context, NO);

	CGContextSetStrokeColorWithColor(context, [self.foregroundColor CGColor]);
	CGContextSetFillColorWithColor(context, [self.backgroundColor CGColor]);

	CGContextSetLineWidth(context, kElementViewLineWidth);

	if ([self.bt isEqualToString:@"."])
		CGContextSetLineDash(context, 0, dashedLengths, dashedLengthsSize);
	else if ([self.bt isEqualToString:@"*"])
		CGContextSetLineWidth(context, kElementViewLineWidth * 4);

	CGContextFillRect(context, self.boundingRect);
	CGContextStrokeRect(context, self.boundingRect);

	if (self.activeClass)
	{
		CGMutablePathRef	 path = CGPathCreateMutable();

		CGPathMoveToPoint(path, NULL, CGRectGetMinX(self.boundingRect) + self.activeSpace, CGRectGetMinY(self.boundingRect));
		CGPathAddLineToPoint(path, NULL, CGRectGetMinX(self.boundingRect) + self.activeSpace, CGRectGetMinY(self.boundingRect) + CGRectGetHeight(self.boundingRect));

		CGPathMoveToPoint(path, NULL, CGRectGetMinX(self.boundingRect) + CGRectGetWidth(self.boundingRect) - self.activeSpace, CGRectGetMinY(self.boundingRect));
		CGPathAddLineToPoint(path, NULL, CGRectGetMinX(self.boundingRect) + CGRectGetWidth(self.boundingRect) - self.activeSpace, CGRectGetMinY(self.boundingRect) + CGRectGetHeight(self.boundingRect));

		CGContextAddPath(context, path);
		CGContextDrawPath(context, kCGPathStroke);

		CGPathRelease(path);
	}

	[self drawTextInContext:context];

	CGContextRestoreGState(context);
}

@end
