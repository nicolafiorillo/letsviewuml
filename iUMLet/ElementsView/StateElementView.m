//
//  StateElementView.m
//  Let's view UML
//
//  Created by Nicola Fiorillo on 9/13/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import "StateElementView.h"
#import <QuartzCore/QuartzCore.h>

static CGFloat const kAngleRay = 16.0f;

@interface StateElementView()

@property (nonatomic)CGFloat angleRay;

@end

@implementation StateElementView

+(Class)layerClass
{
	return [CATiledLayer class];
}

- (id)initWithElement:(Element *)element fontGeometry:(FontGeometry *)fontGeometry zoom:(NSInteger)zoom
{
	self = [super initWithElement:element fontGeometry:fontGeometry zoom:zoom];

	if (self)
	{
		self.angleRay = kAngleRay * self.scaleFactor;
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

	UIBezierPath * rectPath = [UIBezierPath bezierPathWithRoundedRect:self.boundingRect cornerRadius:self.angleRay];

	CGContextAddPath(context, [rectPath CGPath]);
	CGContextDrawPath(context, kCGPathFillStroke);

	[self drawTextInContext:context];

	CGContextRestoreGState(context);
}

- (void)drawTextInContext:(CGContextRef)context
{
	int yOffset = 0;
	BOOL centerHorizontally = YES;

	CGContextSaveGState(context);
	CGContextSetStrokeColorWithColor(context, [self.foregroundColor CGColor]);
	CGContextSetFillColorWithColor(context, [self.foregroundColor CGColor]);

	for (TextLine * textLine in self.text)
	{
		if (textLine.isSeparator)
		{
			yOffset += self.fontGeometry.fontSeparatorSpace;

			CGContextMoveToPoint(context, 0, yOffset);
			CGContextAddLineToPoint(context, CGRectGetWidth(self.boundingRect), yOffset);
			CGContextStrokePath(context);

			centerHorizontally = NO;
		}
		else if (textLine.isDashedSeparator)
		{
			yOffset += self.fontGeometry.fontSeparatorSpace;

			CGContextSaveGState(context);

			CGContextSetLineDash(context, 0, dashedLengths, dashedLengthsSize);

			CGContextMoveToPoint(context, 0, yOffset);
			CGContextAddLineToPoint(context, CGRectGetWidth(self.boundingRect), yOffset);
			CGContextStrokePath(context);

			CGContextRestoreGState(context);
		}
		else
		{
			float x = centerHorizontally ? (CGRectGetWidth(self.boundingRect) - textLine.textSize.width) / 2 : self.fontGeometry.fontLeftSpace;
			float y = self.fontGeometry.fontSize + self.fontGeometry.fontUpperSpace;

			y += yOffset;
			yOffset = y;

			[self drawText:textLine inContext:context atX:x atY:y];
		}
	}

	CGContextRestoreGState(context);
}

@end
