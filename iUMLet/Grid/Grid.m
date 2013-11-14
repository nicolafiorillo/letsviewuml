//
//  Grid.m
//  Let's view UML
//
//  Created by Nicola Fiorillo on 7/20/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import "Grid.h"

static CGFloat const kGridGridDistance	= 10.0f;

@implementation Grid

+ (UIImage *)gridForRect:(CGRect)rect scale:(CGFloat)scale
{
	CGRect f = CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetWidth(rect) * scale, CGRectGetHeight(rect) * scale);
	
	UIGraphicsBeginImageContext(f.size);
	CGContextRef context = UIGraphicsGetCurrentContext();

	CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
	CGContextFillRect(context, f);

	[Grid drawGridInContext:context inRect:f withScale:scale];

	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	return image;
}

+ (void)flushBackgroundGridInFile:(NSString*)fileName rect:(CGRect)rect scale:(CGFloat)scale
{
	UIImage * i = [Grid gridForRect:rect scale:scale];
	NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *root = [paths objectAtIndex:0];

	NSString * filepathName = [root stringByAppendingPathComponent:fileName];

	filepathName = [filepathName stringByAppendingPathExtension:@"png"];

	[UIImagePNGRepresentation(i) writeToFile:filepathName atomically:YES];
}

+ (void)flushGridRect:(CGRect)rect inFile:(NSString*)fileName
{
    CGFloat scale = [UIScreen mainScreen].scale;
	UIImage * i = [Grid gridForRect:rect scale:scale];
	
	NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *root = [paths objectAtIndex:0];

	NSString * filepathName = [root stringByAppendingPathComponent:fileName];

	filepathName = [filepathName stringByAppendingPathExtension:@"png"];

	[UIImagePNGRepresentation(i) writeToFile:filepathName atomically:YES];
}

+ (void)drawGridInContext:(CGContextRef)context inRect:(CGRect)rect withScale:(CGFloat)scale
{
	CGContextSaveGState(context);

	CGContextSetLineWidth(context, 0.1);

	int x = 0;
	while (x <= CGRectGetWidth(rect))
	{
		CGContextMoveToPoint(context, x, 0);
		CGContextAddLineToPoint(context, x, CGRectGetHeight(rect));
		CGContextStrokePath(context);

		x = x + (kGridGridDistance * scale);
	}

	int y = 0;
	while (y <= CGRectGetHeight(rect))
	{
		CGContextMoveToPoint(context, 0, y);
		CGContextAddLineToPoint(context, CGRectGetWidth(rect), y);
		CGContextStrokePath(context);

		y = y + (kGridGridDistance * scale);
	}

	CGContextRestoreGState(context);
}

@end
