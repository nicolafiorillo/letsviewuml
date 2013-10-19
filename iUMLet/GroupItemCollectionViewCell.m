//
//  GroupItemCollectionViewCell.m
//  Let's view UML
//
//  Created by Nicola Fiorillo on 8/4/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import "GroupItemCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation GroupItemCollectionViewCell

-(void)drawRect:(CGRect)rect
{
	NSLog(@"Redrawing cell: %@", self.name);

	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);

	CGContextSetShouldAntialias(context, NO);
	
	CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
	CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);

	CGContextSetLineWidth(context, kGenericItemCollectionViewCellLineWidth);

	CGRect bottomRect = CGRectMake(CGRectGetMinX(self.bounds), CGRectGetMinY(self.bounds) + kGenericItemCollectionViewCellSeparatorDistance, CGRectGetWidth(self.bounds) - 1, CGRectGetHeight(self.bounds) - kGenericItemCollectionViewCellSeparatorDistance);
	CGContextFillRect(context, bottomRect);
	CGContextStrokeRect(context, bottomRect);

	CGSize textSize = [self.name sizeWithFont:self.font constrainedToSize:self.bounds.size lineBreakMode:0];
	CGRect textRect = CGRectMake(CGRectGetMinX(self.bounds), CGRectGetMinY(self.bounds) + 1, textSize.width + kGenericItemCollectionViewCellLeftSpace * 2, kGenericItemCollectionViewCellSeparatorDistance - 1);

	CGContextFillRect(context, textRect);
	CGContextStrokeRect(context, textRect);

	[self drawName:context position:GICVC_TextPositionLeft];
//	[self drawPreview:context];

	CGContextRestoreGState(context);
}

@end
