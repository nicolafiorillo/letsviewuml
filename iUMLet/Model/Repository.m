//
//  Repository.m
//  Let's view UML
//
//  Created by Nicola Fiorillo on 7/16/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import "Repository.h"
#import "Canvas.h"
#import "CanvasLoader.h"

@interface Repository()

@property(strong, nonatomic)NSMutableArray * availableItems;		// of Canvas or Repository

@end

@implementation Repository

- (NSMutableArray*)availableItems
{
	if (!_availableItems)
		_availableItems = [self loadAvailableItems];

	return _availableItems;
}

- (NSInteger)numberOfItems
{
	return self.availableItems.count;
}

- (id)itemAtIndex:(NSInteger)index
{
	if (index < 0 || index >= self.availableItems.count)
		return nil;

	return (Canvas *)[self.availableItems objectAtIndex:index];
}

- (Canvas *)loadCanvasAtIndex:(NSInteger)index
{
	Canvas * canvas = [self itemAtIndex:index];
	if (!canvas)
		return nil;

	if (!canvas.isLoaded)
		[CanvasLoader loadFromFile:canvas];

	return canvas;
}

- (NSMutableArray *)loadAvailableItems
{
	NSLog(@"Should not pass here!");
	return nil;
}

@end
