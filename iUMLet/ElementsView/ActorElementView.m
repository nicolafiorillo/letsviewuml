//
//  ActorElementView.m
//  Let's view UML
//
//  Created by Nicola Fiorillo on 7/1/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import "ActorElementView.h"
#import <QuartzCore/QuartzCore.h>

@interface ActorElementView()

@property (nonatomic)CGFloat manHeight;
@property (nonatomic)CGFloat textDistance;
@property (nonatomic)CGFloat headRay;
@property (nonatomic)CGFloat bodyLenght;
@property (nonatomic)CGFloat shoulderLenght;
@property (nonatomic)CGFloat armLenght;
@property (nonatomic)CGFloat footDistance;
@property (nonatomic)CGFloat lineDistance;

@end

static CGFloat const kActorElementMaxHeight			= 70.0f;
static CGFloat const kActorElementTextDistance		= 10.0f;
static CGFloat const kActorElementHeadRay			= 7.0f;
static CGFloat const kActorElementBodyLenght		= 24.0f;
static CGFloat const kActorElementShoulderLenght	= 18.0f;
static CGFloat const kActorElementArmLenght			= 28.0f;
static CGFloat const kActorElementFootDistance		= 36.0f;
static CGFloat const kActorElementLineDistance		= 6.0f;

@implementation ActorElementView

+(Class)layerClass
{
	return [CATiledLayer class];
}

- (id)initWithElement:(Element *)element fontGeometry:(FontGeometry *)fontGeometry zoom:(NSInteger)zoom
{
	self = [super initWithElement:element fontGeometry:fontGeometry zoom:zoom];
	if (self)
	{
		self.manHeight = kActorElementMaxHeight * self.scaleFactor;
		self.textDistance = kActorElementTextDistance * self.scaleFactor;
		self.headRay = kActorElementHeadRay * self.scaleFactor;
		self.bodyLenght = kActorElementBodyLenght * self.scaleFactor;
		self.shoulderLenght = kActorElementShoulderLenght * self.scaleFactor;
		self.armLenght = kActorElementArmLenght * self.scaleFactor;
		self.footDistance = kActorElementFootDistance * self.scaleFactor;
		self.lineDistance = kActorElementLineDistance * self.scaleFactor;
	}

	return self;
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)context
{
	CGContextSaveGState(context);

	CGContextSetStrokeColorWithColor(context, [self.foregroundColor CGColor]);
	CGContextSetFillColorWithColor(context, [self.backgroundColor CGColor]);

	CGContextSetLineWidth(context, kElementViewLineWidth);

	// head
	CGFloat centerX = CGRectGetWidth(self.boundingRect) / 2;
	CGRect head = CGRectMake(centerX - self.headRay, 0, self.headRay * 2, self.headRay * 2);
	CGContextFillEllipseInRect(context, head);
	CGContextStrokeEllipseInRect(context, head);

	// body
	CGContextMoveToPoint(context, centerX, self.headRay * 2);
	CGContextAddLineToPoint(context, centerX, (self.headRay * 2) + self.bodyLenght);

	// left leg
	CGContextMoveToPoint(context, centerX, (self.headRay * 2) + self.bodyLenght);
	CGContextAddLineToPoint(context, self.footDistance, self.manHeight);

	// right leg
	CGContextMoveToPoint(context, centerX, (self.headRay * 2) + self.bodyLenght);
	CGContextAddLineToPoint(context, CGRectGetWidth(self.boundingRect) - self.footDistance, self.manHeight);

	// arms
	CGContextMoveToPoint(context, centerX - self.armLenght, self.shoulderLenght);
	CGContextAddLineToPoint(context, centerX + self.armLenght, self.shoulderLenght);

	[self drawTextInContext:context at:self.manHeight + self.textDistance];

	CGContextStrokePath(context);
	CGContextRestoreGState(context);
}

- (void)drawTextInContext:(CGContextRef)context at:(CGFloat)offset
{
	int yOffset = offset;

	CGContextSaveGState(context);
	CGContextSetStrokeColorWithColor(context, [self.foregroundColor CGColor]);
	CGContextSetFillColorWithColor(context, [self.foregroundColor CGColor]);

	for (TextLine * textLine in self.text)
	{
		if (textLine.isSeparator)
		{
			yOffset += kActorElementLineDistance;

			CGContextMoveToPoint(context, 0, yOffset);
			CGContextAddLineToPoint(context, CGRectGetWidth(self.boundingRect), yOffset);
			CGContextStrokePath(context);
		}
		else
		{
			float x = (CGRectGetWidth(self.boundingRect) - textLine.textSize.width) / 2;
			float y = self.fontGeometry.fontSize + self.fontGeometry.fontUpperSpace;

			y += yOffset;
			yOffset = y;

			[self drawText:textLine inContext:context atX:x atY:y];
		}
	}

	CGContextRestoreGState(context);
}

@end
