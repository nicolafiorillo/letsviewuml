//
//  Geometry.h
//  Let's view UML
//
//  Created by Nicola Fiorillo on 7/15/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import <Foundation/Foundation.h>

struct GSegment
{
	CGPoint pointer;
	CGPoint direction;
};
typedef struct GSegment GSegment;

@interface Geometry : NSObject

+ (CGPoint)centerOfRect:(CGRect)rect;
+ (CGRect)rectWithCenterIn:(CGPoint)center width:(CGFloat)width height:(CGFloat)height;
+ (CGPoint)linesIntersectionPoint:(CGPoint)p1 p2:(CGPoint)p2 p3:(CGPoint)p3 p4:(CGPoint)p4;
+ (CGFloat)angleOfLine:(CGPoint)point direction:(CGPoint)direction;
+ (CGPoint)offsetOf:(CGPoint)pointer direction:(CGPoint)direction distance:(CGFloat)distance angle:(CGFloat)angle;
+ (CGPoint)intersectionPoint:(CGRect)rect outPoint:(CGPoint)outPoint;
+ (CGPoint)centerOfPoints:(NSArray *)points;
+ (CGPoint)centerOfSegments:(NSArray *)points offset:(CGFloat)offset;
+ (GSegment)middleSegment:(NSArray *)points;

@end
