//
//  CanvasView.m
//  Let's view UML
//
//  Created by Nicola Fiorillo on 6/16/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import "CanvasView.h"
#import <QuartzCore/QuartzCore.h>
#import "Element.h"
#import "ElementViewFactory.h"
#import "Grid.h"
#import "Settings.h"

@implementation CanvasView

- (void)setCanvas:(Canvas *)canvas
{
	_canvas = canvas;
	[self reloadCanvasElements];
}

- (CGRect)calculateDimensionsFor:(CGRect)realDimension screenDimension:(CGRect)screenDimension
{
	CGFloat width = MAX(CGRectGetWidth(realDimension), CGRectGetWidth(screenDimension));
	CGFloat height = MAX(CGRectGetHeight(realDimension), CGRectGetHeight(screenDimension));

	CGFloat side = MAX(width, height);

	return CGRectMake(CGRectGetMinX(realDimension), CGRectGetMinY(realDimension), side, side);
}

- (id)initWithCanvas:(Canvas *)canvas
{
	UIScreen * screen = [UIScreen mainScreen];

	CGRect screenRect = CGRectMake(0, 0, CGRectGetWidth(screen.applicationFrame), CGRectGetHeight(screen.applicationFrame));
	CGRect dimension = canvas.isLoaded ? [self calculateDimensionsFor:canvas.dimension screenDimension:screenRect] : screenRect;

	self = [super initWithFrame:dimension];

	if (self)
		self.canvas = canvas;

	return self;
}

- (void)drawRect:(CGRect)rect
{
#warning TODO remove grid for preview (how?)
    
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);
    
	CGContextSetRGBFillColor(context, 255, 255, 255, 1);
    CGContextFillRect(context, self.bounds);
    
	if ([Settings getInstance].showGrid)
		[Grid drawGridInContext:context inRect:self.bounds withScale:1.0f];
    
	CGContextRestoreGState(context);
}

- (void)reloadCanvasElements
{
	for (id element in self.canvas.elements)
	{
		if ([element isKindOfClass:[Element class]])
		{
			ElementView * newView = [ElementViewFactory createWithElement:(Element *)element andZoomLevel:self.canvas.zoomLevel];

			if (newView != nil)
				[self addSubview:newView];
		}
	}
}

@end
