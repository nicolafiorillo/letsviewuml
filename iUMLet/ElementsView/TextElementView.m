//
//  TextElementView.m
//  Let's view UML
//
//  Created by Nicola Fiorillo on 6/30/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import "TextElementView.h"
#import <QuartzCore/QuartzCore.h>

@implementation TextElementView

+(Class)layerClass
{
	return [CATiledLayer class];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)context
{
	CGContextSaveGState(context);

	CGContextSetStrokeColorWithColor(context, [self.foregroundColor CGColor]);
	CGContextSetFillColorWithColor(context, [self.backgroundColor CGColor]);

	[self drawLeftJustifiedInContext:context];

	CGContextRestoreGState(context);
}

@end
