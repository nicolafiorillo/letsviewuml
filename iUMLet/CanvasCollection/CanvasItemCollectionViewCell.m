//
//  CanvasItemCollectionViewCell.m
//  Let's view UML
//
//  Created by Nicola Fiorillo on 7/16/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import "CanvasItemCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation CanvasItemCollectionViewCell

-(void)drawRect:(CGRect)rect
{
	NSLog(@"Redrawing cell: %@", self.name);

	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);

	CGContextSetShouldAntialias(context, NO);

	CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
	CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);

	CGContextSetLineWidth(context, kGenericItemCollectionViewCellLineWidth);

	CGRect r = CGRectMake(CGRectGetMinX(self.bounds), CGRectGetMinY(self.bounds) + 1, CGRectGetWidth(self.bounds) - 1, CGRectGetHeight(self.bounds) - 1);
	CGContextFillRect(context, r);
	CGContextStrokeRect(context, r);

	[self drawName:context position:GICVC_TextPositionCenter];
	[self drawSeparator:context];
	[self drawPreview:context];

	CGContextRestoreGState(context);
}

- (void)drawSeparator:(CGContextRef)context
{
	CGMutablePathRef	 path = CGPathCreateMutable();

	CGPathMoveToPoint(path, NULL, CGRectGetMinX(self.bounds), CGRectGetMinY(self.bounds) + kGenericItemCollectionViewCellSeparatorDistance);
	CGPathAddLineToPoint(path, NULL, CGRectGetMinX(self.bounds) + CGRectGetWidth(self.bounds), CGRectGetMinY(self.bounds) + kGenericItemCollectionViewCellSeparatorDistance);

	CGContextAddPath(context, path);
	CGContextDrawPath(context, kCGPathStroke);

	CGPathRelease(path);
}

@end
