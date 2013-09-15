//
//  InterfaceElementView.m
//  Let's view UML
//
//  Created by Nicola Fiorillo on 7/9/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import "InterfaceElementView.h"
#import <QuartzCore/QuartzCore.h>

@interface InterfaceElementView()

@property (nonatomic)CGFloat circleRay;
@property (nonatomic)CGFloat lineSPace;

@end

@implementation InterfaceElementView

+(Class)layerClass
{
	return [CATiledLayer class];
}

static CGFloat const kInterfaceElementCircleRay	= 10.0f;
static CGFloat const kInterfaceElementLineSpace	= 5.0f;

- (id)initWithElement:(Element *)element andZoom:(NSInteger)zoom
{
	self = [super initWithElement:element andZoom:zoom];

	if (self)
	{
		self.circleRay = kInterfaceElementCircleRay * self.scaleFactor;
		self.lineSPace = kInterfaceElementLineSpace * self.scaleFactor;
	}

	return self;
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)context
{
	CGContextSaveGState(context);

	CGContextSetStrokeColorWithColor(context, [self.foregroundColor CGColor]);
	CGContextSetFillColorWithColor(context, [self.backgroundColor CGColor]);

	CGContextSetLineWidth(context, kElementViewLineWidth);

	CGFloat centerX = CGRectGetWidth(self.boundingRect) / 2;
	CGRect head = CGRectMake(centerX - self.circleRay, 0.5, self.circleRay * 2, self.circleRay * 2);
	CGContextFillEllipseInRect(context, head);
	CGContextStrokeEllipseInRect(context, head);

	[self drawText:context];

	CGContextRestoreGState(context);
}

- (void)drawText:(CGContextRef)context
{
	int yOffset = self.circleRay * 2;
	CGContextSaveGState(context);
	CGContextSetStrokeColorWithColor(context, [self.foregroundColor CGColor]);
	CGContextSetFillColorWithColor(context, [self.foregroundColor CGColor]);

	for (TextLine * textLine in self.text)
	{
		if (textLine.isSeparator)
		{
			yOffset += self.lineSPace;

			CGContextMoveToPoint(context, 0, yOffset);
			CGContextAddLineToPoint(context, CGRectGetWidth(self.boundingRect), yOffset);
			CGContextStrokePath(context);
		}
		else
		{
			float x = (CGRectGetWidth(self.boundingRect) - textLine.textSize.width) / 2;
			float y = self.fontSize + self.fontUpperSpace;

			y += yOffset;
			yOffset = y;

			[self drawText:textLine inContext:context atX:x atY:y];
		}
	}

	CGContextRestoreGState(context);
}

@end
