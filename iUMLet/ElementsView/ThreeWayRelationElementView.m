//
//  ThreeWayRelationElementView.m
//  Let's view UML
//
//  Created by Nicola Fiorillo on 7/15/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import "ThreeWayRelationElementView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ThreeWayRelationElementView

+(Class)layerClass
{
	return [CATiledLayer class];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)context
{
	CGContextSaveGState(context);

	CGContextSetStrokeColorWithColor(context, [self.foregroundColor CGColor]);
	CGContextSetFillColorWithColor(context, [self.backgroundColor CGColor]);

	CGContextSetLineWidth(context, kElementViewLineWidth);

	CGMutablePathRef	 path = CGPathCreateMutable();

	CGPathMoveToPoint(path, NULL, CGRectGetMinX(self.boundingRect) + CGRectGetWidth(self.boundingRect) / 2, CGRectGetMinY(self.boundingRect));
	CGPathAddLineToPoint(path, NULL, CGRectGetMinX(self.boundingRect) + CGRectGetWidth(self.boundingRect), CGRectGetMinY(self.boundingRect) + CGRectGetHeight(self.boundingRect) / 2);
	CGPathAddLineToPoint(path, NULL, CGRectGetMinX(self.boundingRect) + CGRectGetWidth(self.boundingRect) / 2, CGRectGetMinY(self.boundingRect) + CGRectGetHeight(self.boundingRect));
	CGPathAddLineToPoint(path, NULL, CGRectGetMinX(self.boundingRect), CGRectGetMinY(self.boundingRect) + CGRectGetHeight(self.boundingRect) / 2);
	CGPathCloseSubpath(path);

	CGContextAddPath(context, path);
	CGContextDrawPath(context, kCGPathStroke);

	CGPathRelease(path);

	[self drawTextInContext:context];

	CGContextRestoreGState(context);
}

- (void)drawTextInContext:(CGContextRef)context
{
	int yOffset = 0;

	CGContextSaveGState(context);
	CGContextSetStrokeColorWithColor(context, [self.foregroundColor CGColor]);
	CGContextSetFillColorWithColor(context, [self.foregroundColor CGColor]);

	for (TextLine * textLine in self.text)
	{
		float x = self.fontLeftSpace;
		float y = self.fontSize + self.fontUpperSpace;

		y += yOffset;
		yOffset = y;

		[self drawText:textLine inContext:context atX:x atY:y];
	}

	CGContextRestoreGState(context);
}

@end
