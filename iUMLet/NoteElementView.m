//
//  NoteElementView.m
//  Let's view UML
//
//  Created by Nicola Fiorillo on 6/30/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import "NoteElementView.h"
#import <QuartzCore/QuartzCore.h>

static CGFloat const kNoteElementFlapLength = 14.0f;

@interface NoteElementView()

@property (nonatomic)CGFloat linguettaLenght;

@end

@implementation NoteElementView

+(Class)layerClass
{
	return [CATiledLayer class];
}

- (id)initWithElement:(Element *)element andZoom:(NSInteger)zoom
{
	self = [super initWithElement:element andZoom:zoom];

	if (self)
	{
		self.linguettaLenght = kNoteElementFlapLength * self.scaleFactor;
	}

	return self;
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)context
{
	CGContextSaveGState(context);

	CGContextSetStrokeColorWithColor(context, [self.foregroundColor CGColor]);
	CGContextSetFillColorWithColor(context, [self.backgroundColor CGColor]);

	CGContextSetLineWidth(context, kElementViewLineWidth);

	// rect with angle
	CGMutablePathRef	 path = CGPathCreateMutable();

	CGPathMoveToPoint(path, NULL, CGRectGetMinX(self.boundingRect), CGRectGetMinY(self.boundingRect));
	CGPathAddLineToPoint(path, NULL, CGRectGetMinX(self.boundingRect) + CGRectGetWidth(self.boundingRect) - self.linguettaLenght, CGRectGetMinY(self.boundingRect));
	CGPathAddLineToPoint(path, NULL, CGRectGetMinX(self.boundingRect) + CGRectGetWidth(self.boundingRect), CGRectGetMinY(self.boundingRect) + self.linguettaLenght);
	CGPathAddLineToPoint(path, NULL, CGRectGetMinX(self.boundingRect) + CGRectGetWidth(self.boundingRect), CGRectGetMinY(self.boundingRect) + CGRectGetHeight(self.boundingRect));
	CGPathAddLineToPoint(path, NULL, CGRectGetMinX(self.boundingRect), CGRectGetMinY(self.boundingRect) + CGRectGetHeight(self.boundingRect));
	CGPathCloseSubpath(path);

	CGContextAddPath(context, path);
	CGContextDrawPath(context, kCGPathFillStroke);

	CGPathRelease(path);

	// linguetta
	path = CGPathCreateMutable();

	CGPathMoveToPoint(path, NULL, CGRectGetMinX(self.boundingRect) + CGRectGetWidth(self.boundingRect) - self.linguettaLenght, CGRectGetMinY(self.boundingRect));
	CGPathAddLineToPoint(path, NULL, CGRectGetMinX(self.boundingRect) + CGRectGetWidth(self.boundingRect) - self.linguettaLenght, CGRectGetMinY(self.boundingRect) + self.linguettaLenght);
	CGPathAddLineToPoint(path, NULL, CGRectGetMinX(self.boundingRect) + CGRectGetWidth(self.boundingRect), CGRectGetMinY(self.boundingRect) + self.linguettaLenght);

	CGContextAddPath(context, path);
	CGContextStrokePath(context);
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
