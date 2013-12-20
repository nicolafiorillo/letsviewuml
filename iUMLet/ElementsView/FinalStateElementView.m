//
//  FinalStateElementView.m
//  Let's view UML
//
//  Created by Nicola Fiorillo on 9/13/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import "FinalStateElementView.h"
#import <QuartzCore/QuartzCore.h>

static CGFloat const kActorElementExternalRay = 9.5f;
static CGFloat const kActorElementInternalRay = 6.0f;

@interface FinalStateElementView()

@property (nonatomic)CGFloat externalRay;
@property (nonatomic)CGFloat internalRay;

@end

@implementation FinalStateElementView

+(Class)layerClass
{
	return [CATiledLayer class];
}

- (id)initWithElement:(Element *)element fontGeometry:(FontGeometry *)fontGeometry zoom:(NSInteger)zoom
{
	self = [super initWithElement:element fontGeometry:fontGeometry zoom:zoom];
	if (self)
	{
		self.externalRay = kActorElementExternalRay * self.scaleFactor;
		self.internalRay = kActorElementInternalRay * self.scaleFactor;
	}

	return self;
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)context
{
	CGContextSaveGState(context);

	CGFloat centerX = CGRectGetWidth(self.boundingRect) / 2;
	CGFloat centerY = CGRectGetHeight(self.boundingRect) / 2;
	CGRect externalBall = CGRectMake(centerX - self.externalRay, centerY - self.externalRay, self.externalRay * 2, self.externalRay * 2);

	CGContextStrokeEllipseInRect(context, externalBall);

	CGRect internalBall = CGRectMake(centerX - self.internalRay, centerY - self.internalRay, self.internalRay * 2, self.internalRay * 2);
	CGContextFillEllipseInRect(context, internalBall);

	CGContextRestoreGState(context);
}

@end
