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

	[self drawContent:self.boundingRect context:context];

	CGContextRestoreGState(context);
}

- (void)drawContent:(CGRect)rect context:(CGContextRef)context
{
	int yOffset = 0;
	BOOL centerHorizontally = YES;

	CGContextSaveGState(context);
	CGContextSetStrokeColorWithColor(context, [self.foregroundColor CGColor]);
	CGContextSetFillColorWithColor(context, [self.foregroundColor CGColor]);

	for (TextLine * textLine in self.text)
	{
		CGFloat rectWidth = CGRectGetWidth(rect);
		
		if (textLine.isSeparator)
		{
			yOffset += self.fontSeparatorSpace;

			CGContextMoveToPoint(context, 0, yOffset);
			CGContextAddLineToPoint(context, rectWidth, yOffset);
			CGContextStrokePath(context);

			centerHorizontally = NO;
		}
		else
		{
			float x = centerHorizontally ? (rectWidth - textLine.textSize.width) / 2 : self.fontLeftSpace;
			float y = self.fontSize + self.fontUpperSpace;

			y += yOffset;
			yOffset = y;

			[self drawText:textLine inContext:context atX:x atY:y];
		}
	}

	CGContextRestoreGState(context);
}

@end
