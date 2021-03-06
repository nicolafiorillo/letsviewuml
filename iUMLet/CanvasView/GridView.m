//
//  GridView.m
//  Let's view UML
//
//  Created by Nicola Fiorillo on 14/11/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "GridView.h"
#import "Grid.h"
#import "Const.h"

@implementation GridView

+(Class)layerClass
{
	return [CATiledLayer class];
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
	
	if (self) {
		CATiledLayer * thisTiledLayer = (CATiledLayer *)self.layer;
		thisTiledLayer.levelsOfDetail = kLevelsOfDetail;
		thisTiledLayer.levelsOfDetailBias = kLevelsOfDetailBias;
		
		self.opaque = NO;
	}
	
	return self;
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)context
{
	CGContextSaveGState(context);

	CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    CGContextFillRect(context, self.bounds);
    
	[Grid drawGridInContext:context inRect:self.bounds withScale:1.0f];

	CGContextRestoreGState(context);
}

- (void)drawRect:(CGRect)rect
{
}

@end
