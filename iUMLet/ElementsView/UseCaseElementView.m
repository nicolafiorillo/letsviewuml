//
//  UseCaseElementView.m
//  Let's view UML
//
//  Created by Nicola Fiorillo on 6/25/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import "UseCaseElementView.h"
#import <QuartzCore/QuartzCore.h>

@implementation UseCaseElementView

+(Class)layerClass
{
	return [CATiledLayer class];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)context
{
	CGContextSaveGState(context);

	CGContextSetLineWidth(context, kElementViewLineWidth);

	if ([self.lt isEqualToString:@"."])
		CGContextSetLineDash(context, 0, dashedLengths, dashedLengthsSize);

	CGContextSetStrokeColorWithColor(context, [self.foregroundColor CGColor]);
	CGContextSetFillColorWithColor(context, [self.backgroundColor CGColor]);

	CGRect dimension = CGRectMake(CGRectGetMinX(self.boundingRect) + kElementViewLineWidth / 2, CGRectGetMinY(self.boundingRect) + kElementViewLineWidth / 2, CGRectGetWidth(self.boundingRect) - kElementViewLineWidth, CGRectGetHeight(self.boundingRect) - kElementViewLineWidth);
	
	CGContextFillEllipseInRect(context, dimension);
	CGContextStrokeEllipseInRect(context, dimension);

	[self drawTextVerticallyInContext:context];

	CGContextRestoreGState(context);
}

@end
