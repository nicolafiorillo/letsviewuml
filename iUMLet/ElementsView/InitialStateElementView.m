//
//  InitialStateElementView.m
//  Let's view UML
//
//  Created by Nicola Fiorillo on 9/13/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import "InitialStateElementView.h"
#import <QuartzCore/QuartzCore.h>

static CGFloat const kActorElementRay = 10.0f;

@interface InitialStateElementView()

@property (nonatomic)CGFloat ray;

@end

@implementation InitialStateElementView

+(Class)layerClass
{
	return [CATiledLayer class];
}

- (id)initWithElement:(Element *)element andZoom:(NSInteger)zoom
{
	self = [super initWithElement:element andZoom:zoom];
	if (self)
		self.ray = kActorElementRay * self.scaleFactor;

	return self;
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)context
{
	CGContextSaveGState(context);

	CGFloat centerX = CGRectGetWidth(self.boundingRect) / 2;
	CGFloat centerY = CGRectGetHeight(self.boundingRect) / 2;
	CGRect ball = CGRectMake(centerX - self.ray, centerY - self.ray, self.ray * 2, self.ray * 2);

	CGContextFillEllipseInRect(context, ball);

	CGContextRestoreGState(context);
}

@end
