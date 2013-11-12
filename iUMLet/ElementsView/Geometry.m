//
//  Geometry.m
//  Let's view UML
//
//  Created by Nicola Fiorillo on 7/15/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import "Geometry.h"

@implementation Geometry

+ (CGPoint)centerOfRect:(CGRect)rect
{
	return CGPointMake(CGRectGetMinX(rect) + CGRectGetWidth(rect) / 2, CGRectGetMinY(rect) + CGRectGetHeight(rect) / 2);
}

+ (CGRect)rectWithCenterIn:(CGPoint)center width:(CGFloat)width height:(CGFloat)height
{
	return CGRectMake(center.x - (width / 2), center.y - (width / 2), width, height);
}

+ (CGPoint)linesIntersectionPoint:(CGPoint)p1 p2:(CGPoint)p2 p3:(CGPoint)p3 p4:(CGPoint)p4
{
	CGFloat A1 = p2.y - p1.y;
	CGFloat B1 = p1.x - p2.x;
	CGFloat C1 = A1 * p1.x + B1 * p1.y;

	CGFloat A2 = p4.y - p3.y;
	CGFloat B2 = p3.x - p4.x;
	CGFloat C2 = A2 * p3.x + B2 * p3.y;

	CGFloat det = A1 * B2 - A2 * B1;

	CGPoint intersection = CGPointZero;

	if (det != 0)
	{
		CGPoint p = CGPointMake((B2 * C1 - B1 * C2) / det, (A1 * C2 - A2 * C1) / det);

		// if point is inside segments
		if (p.x >= MIN(p1.x, p2.x) && p.x <= MAX(p1.x, p2.x) && p.y >= MIN(p1.y, p2.y) && p.y <= MAX(p1.y, p2.y) &&
			p.x >= MIN(p3.x, p4.x) && p.x <= MAX(p3.x, p4.x) && p.y >= MIN(p3.y, p4.y) && p.y <= MAX(p3.y, p4.y))
				intersection = p;
	}

	return intersection;
}

+ (CGFloat)angleOfLine:(CGPoint)point direction:(CGPoint)direction
{
	return atan2f(direction.y - point.y, direction.x - point.x);
}

+ (CGPoint)offsetOf:(CGPoint)pointer direction:(CGPoint)direction distance:(CGFloat)distance angle:(CGFloat)angle
{
	CGFloat currentAngle = [Geometry angleOfLine:pointer direction:direction];
	return CGPointMake(pointer.x + cosf(currentAngle + angle) * distance, pointer.y + sin(currentAngle + angle) * distance);
}

+ (CGPoint)intersectionPoint:(CGRect)rect outPoint:(CGPoint)outPoint
{
	CGPoint center = CGPointMake(CGRectGetMinX(rect) + CGRectGetWidth(rect) / 2, CGRectGetMinY(rect) + CGRectGetHeight(rect) / 2);

	//top
	CGPoint p = [Geometry linesIntersectionPoint:center p2:outPoint p3:rect.origin p4:CGPointMake(CGRectGetMinX(rect) + CGRectGetWidth(rect), CGRectGetMinY(rect))];
	if (!CGPointEqualToPoint(p, CGPointZero))
		return p;

	//bottom
	p = [Geometry linesIntersectionPoint:center p2:outPoint p3:CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect) + CGRectGetHeight(rect)) p4:CGPointMake(CGRectGetMinX(rect) + CGRectGetWidth(rect), CGRectGetMinY(rect) + CGRectGetHeight(rect))];
	if (!CGPointEqualToPoint(p, CGPointZero))
		return p;

	//left
	p = [Geometry linesIntersectionPoint:center p2:outPoint p3:rect.origin p4:CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect) + CGRectGetHeight(rect))];
	if (!CGPointEqualToPoint(p, CGPointZero))
		return p;

	//right
	p = [Geometry linesIntersectionPoint:center p2:outPoint p3:CGPointMake(CGRectGetMinX(rect) + CGRectGetWidth(rect), CGRectGetMinY(rect)) p4:CGPointMake(CGRectGetMinX(rect) + CGRectGetWidth(rect), CGRectGetMinY(rect) + CGRectGetHeight(rect))];
	if (!CGPointEqualToPoint(p, CGPointZero))
		return p;

	return CGPointZero;
}

+ (CGPoint)centerOfPoints:(NSArray *)points
{
	if (points.count < 2)
		return CGPointZero;

	CGPoint center = CGPointZero;

	if (points.count % 2 == 0)
	{
		CGPoint first = [(NSValue*)points[(points.count / 2) - 1] CGPointValue];
		CGPoint second = [(NSValue*)points[points.count / 2] CGPointValue];
		center = CGPointMake(first.x + (second.x - first.x) / 2, first.y + (second.y - first.y) / 2);
	}
	else
		center = [(NSValue*)points[points.count / 2] CGPointValue];

	return center;
}

+ (GSegment)middleSegment:(NSArray *)points
{
	GSegment s;
	s.pointer	= CGPointZero;
	s.direction = CGPointZero;

	if (points.count < 2)
		return s;

	BOOL even = points.count % 2 == 0;

	NSUInteger firstIndex = even ? (points.count / 2) - 1 : points.count / 2;
	NSUInteger secondIndex = even ? points.count / 2 : (points.count / 2) + 1;

	CGPoint first = [(NSValue*)points[firstIndex] CGPointValue];
	CGPoint second = [(NSValue*)points[secondIndex] CGPointValue];

	s.pointer	= first;
	s.direction = second;

	return s;
}

+ (CGPoint)centerOfSegments:(NSArray *)points offset:(CGFloat)offset
{
	if (points.count < 2)
		return CGPointZero;

	GSegment middleSegment = [Geometry middleSegment:points];

	CGPoint center = CGPointMake(middleSegment.pointer.x + (middleSegment.direction.x - middleSegment.pointer.x) / 2, middleSegment.pointer.y + (middleSegment.direction.y - middleSegment.pointer.y) / 2);

	if (offset != 0.0f)
		center = [Geometry offsetOf:center direction:middleSegment.direction distance:offset angle:0.0f];

	return center;
}

@end
