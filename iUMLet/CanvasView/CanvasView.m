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
#import "GridView.h"

@implementation CanvasView

- (void)setCanvas:(Canvas *)canvas
{
	_canvas = canvas;
	[self reloadCanvasElements];
}

- (void)setShowGrid:(BOOL)showGrid
{
	if (self.canvas)
	{
		GridView * gridView = (GridView *)self.subviews.firstObject;
		gridView.hidden = !showGrid;
	}
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

	CGFloat maxSide = MAX(CGRectGetWidth(screen.bounds), CGRectGetHeight(screen.bounds));
	CGRect screenRect = CGRectMake(0, 0, maxSide, maxSide);
	CGRect dimension = canvas.isLoaded ? [self calculateDimensionsFor:canvas.dimension screenDimension:screenRect] : screenRect;

	self = [super initWithFrame:dimension];

	if (self)
		self.canvas = canvas;

	return self;
}

- (void)reloadCanvasElements
{
#warning TODO remove grid for preview (how?)

	for (UIView * v in self.subviews)
		 [v removeFromSuperview];
	
	GridView * gridView = [[GridView alloc] initWithFrame:self.bounds];
	[self addSubview:gridView];
	
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
