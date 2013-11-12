//
//  Canvas.m
//  Let's view UML
//
//  Created by Nicola Fiorillo on 6/5/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import "Canvas.h"
#import "Element.h"

@interface Canvas()

@property (strong, nonatomic, readwrite)NSString * fullPath;
@property (strong, nonatomic, readwrite)NSString * name;
@property (strong, nonatomic, readwrite)NSString * source;

@end

@implementation Canvas

- (id)initWithFullPath:(NSString *)path andSource:(NSString *)source
{
	self = [super init];

	if (self)
	{
		self.fullPath = path;
		self.source = source;
		self.name = [[path.pathComponents lastObject] stringByDeletingPathExtension];

		self.loaded = NO;
	}

	return self;
}

- (NSMutableArray *)elements
{
	if (!_elements)
		_elements = [[NSMutableArray alloc] init];

	return _elements;
}

- (CGRect)dimension
{
	if (self.elements.count == 0)
		return CGRectNull;

	CGFloat minX = MAXFLOAT;
	CGFloat minY = MAXFLOAT;
	CGFloat maxX = 0;
	CGFloat maxY = 0;

	for (id element in self.elements)
	{
		if ([element isKindOfClass:[Element class]])
		{
			Element * e = (Element *)element;
			minX = MIN(minX, CGRectGetMinX(e.coordinates));
			minY = MIN(minY, CGRectGetMinY(e.coordinates));

			maxX = MAX(maxX, CGRectGetMinX(e.coordinates) + CGRectGetWidth(e.coordinates));
			maxY = MAX(maxY, CGRectGetMinY(e.coordinates) + CGRectGetHeight(e.coordinates));
		}
	}

	return CGRectMake(0, 0, maxX + minX, maxY + minY);
}

- (CGPoint)topLeftElementOrigin
{
	if (self.elements.count == 0)
		return CGPointZero;

	CGFloat minX = MAXFLOAT;
	CGFloat minY = MAXFLOAT;

	for (id element in self.elements)
	{
		if ([element isKindOfClass:[Element class]])
		{
			Element * e = (Element *)element;
			minX = MIN(minX, CGRectGetMinX(e.coordinates));
			minY = MIN(minY, CGRectGetMinY(e.coordinates));
		}
	}

	return CGPointMake(minX, minY);
}

@end
