//
//  RelationElementView.m
//  Let's view UML
//
//  Created by Nicola Fiorillo on 6/21/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import "RelationElementView.h"
#import "Geometry.h"
#import <QuartzCore/QuartzCore.h>

typedef NS_ENUM(NSUInteger, TerminalSymbol)
{
	TerminalSymbolNone,
	TerminalSymbolArrow,
	TerminalSymbolClosedArrow,
	TerminalSymbolDiamond,
	TerminalSymbolFilledDiamond,
	TerminalSymbolFilledClosedArrow,
	TerminalSymbolCrossed,
	TerminalSymbolBall,
	TerminalSymbolHalfMoon
};

typedef NS_ENUM(NSUInteger, CenterSymbol)
{
	CenterSymbolNone,
	CenterSymbolBall,
	CenterSymbolBallAndLeftHalfMoon,
	CenterSymbolBallAndRightHalfMoon,
	CenterSymbolLeftHalfMoon,
	CenterSymbolRightHalfMoon
};

typedef NS_ENUM(NSUInteger, LineType)
{
	LineTypeSolid,
	LineTypeDashed,
	LineTypeDoubleSolid,
	LineTypeDoubleDashed
};

static CGFloat DegreesToRadians(CGFloat degrees) { return degrees * M_PI / 180; };
static CGFloat RadiansToDegrees(CGFloat radians) { return radians * 180 / M_PI; };

static CGFloat const kRelationElementArrowWingLength			= 13.0f;
static CGFloat const kRelationElementAccessorXOffset			= 15.0f;
static CGFloat const kRelationElementAccessorYMOffset			= 5.0f;
static CGFloat const kRelationElementAccessorSpaceOffset		= 5.0f;
static CGFloat const kRelationElementQualificationSpace			= 12.0f;
static CGFloat const kRelationElementQualificationHeight		= 20.0f;
static CGFloat const kRelationElementQualificationTextOffset	= -2.0f;
static CGFloat const kRelationElementCrossDistance				= 20.0f;
static CGFloat const kRelationElementCrossSideLenght			= 10.0f;
static CGFloat const kRelationElementBallRay					= 10.0f;
static CGFloat const kRelationElementHalfMoonRay				= 15.0f;
static CGFloat const kRelationElementBallOffsetByHalfMoon		= -5.0f;
static CGFloat const kRelationElementArrowWingAngle				= 27 * M_PI / 180;

@interface RelationElementView()

@property (nonatomic)TerminalSymbol leftSymbol;
@property (nonatomic)TerminalSymbol rightSymbol;
@property (nonatomic)CenterSymbol centerSymbol;
@property (nonatomic)LineType lineType;

@property (nonatomic)CGFloat arrowWingLenght;
@property (nonatomic)CGFloat ballRay;
@property (nonatomic)CGFloat halfMoonRay;
@property (nonatomic)CGFloat ballOffsetByHalfMoon;

@property (nonatomic)CGFloat accessorXOffset;
@property (nonatomic)CGFloat accessorYMOffset;
@property (nonatomic)CGFloat accessorSpaceffset;
@property (nonatomic)CGFloat qualificationSpace;
@property (nonatomic)CGFloat qualificationHeight;
@property (nonatomic)CGFloat qualificationTextOffset;

@property (nonatomic)CGFloat crossDistance;
@property (nonatomic)CGFloat crossSideLenght;

@end

@implementation RelationElementView

+(Class)layerClass
{
	return [CATiledLayer class];
}

+ (BOOL)terminalIsBalls:(TerminalSymbol)terminal
{
	return terminal == TerminalSymbolBall || terminal == TerminalSymbolHalfMoon;
}

+ (BOOL)terminalIsArrow:(TerminalSymbol)terminal
{
	return terminal == TerminalSymbolArrow || terminal == TerminalSymbolClosedArrow || terminal == TerminalSymbolFilledClosedArrow;
}

+ (BOOL)terminalIsDiamond:(TerminalSymbol)terminal
{
	return terminal == TerminalSymbolDiamond || terminal == TerminalSymbolFilledDiamond;
}

+ (BOOL)terminalIsCrossed:(TerminalSymbol)terminal
{
	return terminal == TerminalSymbolCrossed;
}

+ (BOOL)lineTypeIsDashed:(LineType)line
{
	return line == LineTypeDashed;
}

+ (BOOL)lineTypeIsDouble:(LineType)line
{
	return line == LineTypeDoubleSolid || line == LineTypeDoubleDashed;
}

- (CGFloat)arrowWingLenght
{
	return kRelationElementArrowWingLength * self.scaleFactor;
}

- (id)initWithElement:(Element *)element andZoom:(NSInteger)zoom
{
	self = [super initWithElement:element andZoom:zoom];

	if (self)
	{
		self.accessorXOffset = kRelationElementAccessorXOffset * self.scaleFactor;
		self.accessorYMOffset = kRelationElementAccessorYMOffset * self.scaleFactor;
		self.accessorSpaceffset = kRelationElementAccessorSpaceOffset * self.scaleFactor;
		self.qualificationSpace = kRelationElementQualificationSpace * self.scaleFactor;
		self.qualificationHeight = kRelationElementQualificationHeight * self.scaleFactor;
		self.qualificationTextOffset = kRelationElementQualificationTextOffset * self.scaleFactor;

		self.crossDistance = kRelationElementCrossDistance * self.scaleFactor;
		self.crossSideLenght  = kRelationElementCrossSideLenght * self.scaleFactor;
		self.ballRay  = kRelationElementBallRay * self.scaleFactor;
		self.halfMoonRay  = kRelationElementHalfMoonRay * self.scaleFactor;
		self.ballOffsetByHalfMoon = kRelationElementBallOffsetByHalfMoon * self.scaleFactor;

		[self readAttributes];
		[self calcQualificators];
	}
	
	return self;
}

- (CGPoint)calcQualification:(TextLine *)q pa:(CGPoint)pa pb:(CGPoint)pb
{
	CGPoint newStartPoint = CGPointZero;
	
	CGRect qRect = CGRectIntegral(CGRectMake(pa.x - self.qualificationSpace - q.textSize.width / 2, pa.y - self.qualificationHeight / 2, q.textSize.width + self.qualificationSpace * 2, self.qualificationHeight));

	CGPoint center = [Geometry intersectionPoint:qRect outPoint:pb];

	if (!CGPointEqualToPoint(center, CGPointZero))
	{
		qRect = CGRectOffset(qRect, center.x - pa.x, center.y - pa.y);
		q.textFixedPosition = qRect;

		newStartPoint = [Geometry intersectionPoint:qRect outPoint:pb];
	}

	return newStartPoint;
}

- (void)readAttributes
{
	self.leftSymbol = TerminalSymbolNone;
	self.rightSymbol = TerminalSymbolNone;
	self.centerSymbol = CenterSymbolNone;
	self.lineType = LineTypeSolid;

	NSString * content = self.lt;
	
	if ([content rangeOfString:@"<()>"].location != NSNotFound)
		self.leftSymbol = TerminalSymbolBall;
	else if ([content rangeOfString:@"<()"].location != NSNotFound)
		self.leftSymbol = TerminalSymbolBall;
	else if ([content rangeOfString:@"<("].location != NSNotFound)
		self.leftSymbol = TerminalSymbolHalfMoon;
	else if ([content rangeOfString:@"<x"].location != NSNotFound)
		self.leftSymbol = TerminalSymbolCrossed;
	else if ([content rangeOfString:@"<<<<<"].location != NSNotFound)
		self.leftSymbol = TerminalSymbolFilledClosedArrow;
	else if ([content rangeOfString:@"<<<<"].location != NSNotFound)
		self.leftSymbol = TerminalSymbolFilledDiamond;
	else if ([content rangeOfString:@"<<<"].location != NSNotFound)
		self.leftSymbol = TerminalSymbolDiamond;
	else if ([content rangeOfString:@"<<"].location != NSNotFound)
		self.leftSymbol = TerminalSymbolClosedArrow;
	else if ([content rangeOfString:@"<"].location != NSNotFound)
		self.leftSymbol = TerminalSymbolArrow;

	if ([content rangeOfString:@"<()>"].location != NSNotFound)
		self.rightSymbol = TerminalSymbolBall;
	else if ([content rangeOfString:@"()>"].location != NSNotFound)
		self.rightSymbol = TerminalSymbolBall;
	else if ([content rangeOfString:@")>"].location != NSNotFound)
		self.rightSymbol = TerminalSymbolHalfMoon;
	else if ([content rangeOfString:@"x>"].location != NSNotFound)
		self.rightSymbol = TerminalSymbolCrossed;
	else if ([content rangeOfString:@">>>>>"].location != NSNotFound)
		self.rightSymbol = TerminalSymbolFilledClosedArrow;
	else if ([content rangeOfString:@">>>>"].location != NSNotFound)
		self.rightSymbol = TerminalSymbolFilledDiamond;
	else if ([content rangeOfString:@">>>"].location != NSNotFound)
		self.rightSymbol = TerminalSymbolDiamond;
	else if ([content rangeOfString:@">>"].location != NSNotFound)
		self.rightSymbol = TerminalSymbolClosedArrow;
	else if ([content rangeOfString:@">"].location != NSNotFound)
		self.rightSymbol = TerminalSymbolArrow;

	if ([content rangeOfString:@"."].location != NSNotFound)
		self.lineType = LineTypeDashed;
	else if ([content rangeOfString:@"="].location != NSNotFound)
		self.lineType = LineTypeDoubleSolid;
	else if ([content rangeOfString:@":"].location != NSNotFound)
		self.lineType = LineTypeDoubleDashed;

	if (![RelationElementView terminalIsBalls:self.leftSymbol] && ![RelationElementView terminalIsBalls:self.rightSymbol])
	{
		if ([content rangeOfString:@"(()"].location != NSNotFound)
			self.centerSymbol = CenterSymbolBallAndLeftHalfMoon;
		else if ([content rangeOfString:@"())"].location != NSNotFound)
			self.centerSymbol = CenterSymbolBallAndRightHalfMoon;
		else if ([content rangeOfString:@"()"].location != NSNotFound)
			self.centerSymbol = CenterSymbolBall;
		else if ([content rangeOfString:@"("].location != NSNotFound)
			self.centerSymbol = CenterSymbolLeftHalfMoon;
		else if ([content rangeOfString:@")"].location != NSNotFound)
			self.centerSymbol = CenterSymbolRightHalfMoon;
	}
}

- (void)calcQualificators
{
	NSMutableArray * points = self.additionalAttributesPoints;

	if (points.count > 1)
	{
		CGPoint pa = [(NSValue*)points[0] CGPointValue];
		CGPoint pb = [(NSValue*)points[1] CGPointValue];

		if (self.q1 != nil)
		{
			CGPoint newFirstPoint = [self calcQualification:self.q1 pa:pa pb:pb];
			if (!CGPointEqualToPoint(newFirstPoint, CGPointZero))
				[points replaceObjectAtIndex:0 withObject:[NSValue valueWithCGPoint:newFirstPoint]];
		}

		CGPoint pv = [(NSValue*)points[points.count - 2] CGPointValue];
		CGPoint pz = [(NSValue*)points[points.count - 1] CGPointValue];

		if (self.q2 != nil)
		{
			CGPoint newLastPoint = [self calcQualification:self.q2 pa:pz pb:pv];
			if (!CGPointEqualToPoint(newLastPoint, CGPointZero))
				[points replaceObjectAtIndex:points.count - 1 withObject:[NSValue valueWithCGPoint:newLastPoint]];
		}
	}
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)context
{
	CGContextSaveGState(context);

	CGContextSetLineWidth(context, kElementViewLineWidth);

	NSArray * points = self.additionalAttributesPoints;

	if (points.count > 0)
	{
		if ([RelationElementView lineTypeIsDouble:self.lineType])
			[self drawDoubleLine:self.lineType inContext:context withPoints:points];
		else
			[self drawSingleLine:self.lineType inContext:context withPoints:points];

		[self drawTerminalsInContext:context withPoints:points];
	}

//	CGContextStrokeRect(context, self.bounds);
	CGPoint centerOfSegment = [Geometry centerOfPoints:points];
	[self drawTextInContext:context firstLineAt:centerOfSegment.y];

	[self drawAccessoryText:context withPoints:points];

	CGContextRestoreGState(context);
}

- (void)drawSingleLine:(LineType)lineType inContext:(CGContextRef)context withPoints:(NSArray *)points
{
	CGPoint p = [(NSValue*)points[0] CGPointValue];

	CGContextSaveGState(context);
	CGContextMoveToPoint(context, p.x, p.y);

	if (lineType == LineTypeDashed)
		CGContextSetLineDash(context, 0, dashedLengths, dashedLengthsSize);

	for(int i = 1; i < points.count; ++i)
	{
		p = [(NSValue*)points[i] CGPointValue];
		CGContextAddLineToPoint(context, p.x, p.y);
	}

	CGContextStrokePath(context);
	CGContextRestoreGState(context);
}

- (void)drawQualificationText:(TextLine *)q inContext:(CGContextRef)context
{
	if (q != nil)
	{
		CGContextStrokeRect(context, q.textFixedPosition);
		CGRect textRect = CGRectOffset(q.textFixedPosition, 0, self.qualificationTextOffset);
		[self drawText:q inContext:context centerAtPoint:[Geometry centerOfRect:textRect]];
	}
}

- (void)drawTerminalsInContext:(CGContextRef)context withPoints:(NSArray *)points
{
	if (points.count > 1)
	{
		[self drawQualificationText:self.q1 inContext:context];

		CGPoint pa = [(NSValue*)points[0] CGPointValue];
		CGPoint pb = [(NSValue*)points[1] CGPointValue];

		// Drawing left
		if ([RelationElementView terminalIsArrow:self.leftSymbol])
			[self drawArrowWithSymbol:self.leftSymbol inContext:context pointer:pa direction:pb];
		else if ([RelationElementView terminalIsDiamond:self.leftSymbol])
			[self drawDiamondWithSymbol:self.leftSymbol inContext:context pointer:pa direction:pb];
		else if ([RelationElementView terminalIsCrossed:self.leftSymbol])
			[self drawCrossedSymbol:context pointer:pa direction:pb];
		else if ([RelationElementView terminalIsBalls:self.leftSymbol])
			[self drawBallWithSymbol:self.leftSymbol inContext:context pointer:pa direction:pb];

		[self drawQualificationText:self.q2 inContext:context];

		CGPoint pv = [(NSValue*)points[points.count - 2] CGPointValue];
		CGPoint pz = [(NSValue*)points[points.count - 1] CGPointValue];

		// Drawing right
		if ([RelationElementView terminalIsArrow:self.rightSymbol])
			[self drawArrowWithSymbol:self.rightSymbol inContext:context pointer:pz direction:pv];
		else if ([RelationElementView terminalIsDiamond:self.rightSymbol])
			[self drawDiamondWithSymbol:self.rightSymbol inContext:context pointer:pz direction:pv];
		else if ([RelationElementView terminalIsCrossed:self.rightSymbol])
			[self drawCrossedSymbol:context pointer:pz direction:pv];
		else if ([RelationElementView terminalIsBalls:self.rightSymbol])
			[self drawBallWithSymbol:self.rightSymbol inContext:context pointer:pz direction:pv];

		[self drawCenterSymbol:context symbol:self.centerSymbol points:points];
	}
}

- (void)drawArrowWithSymbol:(TerminalSymbol)symbol inContext:(CGContextRef)context pointer:(CGPoint)pointer direction:(CGPoint)direction
{
	CGFloat angle = [Geometry angleOfLine:pointer direction:direction];

	CGPoint end1 = CGPointMake(pointer.x + cosf(angle + kRelationElementArrowWingAngle) * self.arrowWingLenght, pointer.y + sin(angle + kRelationElementArrowWingAngle) * self.arrowWingLenght);
	CGPoint end2 = CGPointMake(pointer.x + cosf(angle - kRelationElementArrowWingAngle) * self.arrowWingLenght, pointer.y + sin(angle - kRelationElementArrowWingAngle) * self.arrowWingLenght);

	CGContextSaveGState(context);

	if (symbol == TerminalSymbolArrow)
	{
		CGContextMoveToPoint(context, end1.x, end1.y);
		CGContextAddLineToPoint(context, pointer.x, pointer.y);
		CGContextAddLineToPoint(context, end2.x, end2.y);

		CGContextStrokePath(context);
	}
	else if (symbol == TerminalSymbolClosedArrow || symbol == TerminalSymbolFilledClosedArrow)
	{
		CGColorRef fillColor = (symbol == TerminalSymbolClosedArrow ? [UIColor whiteColor] : [UIColor blackColor]).CGColor;

		CGContextSetFillColorWithColor(context, fillColor);

		CGMutablePathRef	 path = CGPathCreateMutable();

		CGPathMoveToPoint(path, NULL, end1.x, end1.y);
		CGPathAddLineToPoint(path, NULL, pointer.x, pointer.y);
		CGPathAddLineToPoint(path, NULL, end2.x, end2.y);
		CGPathCloseSubpath(path);

		CGContextAddPath(context, path);
		CGContextDrawPath(context, kCGPathFillStroke);

		CGPathRelease(path);
	}

	CGContextRestoreGState(context);
}

+ (CGPoint)calculateBallOriginWithRay:(CGFloat)ray pointer:(CGPoint)pointer direction:(CGPoint)direction
{
	CGFloat x = pointer.x;
	CGFloat y = pointer.y - ray;

	if (pointer.x < direction.x)
		x -= ray * 2;
	else if (pointer.x == direction.x)
	{
		x -= ray;

		if (pointer.y < direction.y)
			y -= ray;
		else if (pointer.y > direction.y)
			y += ray;
	}

	return CGPointMake(x, y);
}

+ (CGPoint)calculateHalfMoonOrientation:(CGPoint)pointer direction:(CGPoint)direction
{
	CGFloat start = M_PI_2;
	CGFloat end = -M_PI_2;

	if (pointer.x < direction.x)
	{
		start = M_PI_2;
		end = -M_PI_2;
	}
	else if (pointer.x > direction.x)
	{
		start = -M_PI_2;
		end = M_PI_2;
	}
	else
	{
		if (pointer.y < direction.y)
		{
			start = M_PI;
			end = 0;
		}
		else if (pointer.y > direction.y)
		{
			start = 0;
			end = M_PI;
		}
	}

	return CGPointMake(start, end);
}

- (void)drawBallWithSymbol:(TerminalSymbol)symbol inContext:(CGContextRef)context pointer:(CGPoint)pointer direction:(CGPoint)direction
{
	CGContextSaveGState(context);

	CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);

	if (symbol == TerminalSymbolBall)
	{
		CGPoint ballOrigin = [RelationElementView calculateBallOriginWithRay:self.ballRay pointer:pointer direction:direction];

		CGRect ball = CGRectMake(ballOrigin.x, ballOrigin.y, self.ballRay * 2, self.ballRay * 2);
		
		CGContextFillEllipseInRect(context, ball);
		CGContextStrokeEllipseInRect(context, ball);
	}
	else if (symbol == TerminalSymbolHalfMoon)
	{
		CGPoint ballOrigin = [RelationElementView calculateBallOriginWithRay:self.halfMoonRay pointer:pointer direction:direction];

		CGRect ball = CGRectMake(ballOrigin.x, ballOrigin.y, self.halfMoonRay * 2, self.halfMoonRay * 2);

		CGMutablePathRef	 path = CGPathCreateMutable();

		CGPoint center = [Geometry centerOfRect:ball];
		CGPoint orientation = [RelationElementView calculateHalfMoonOrientation:pointer direction:direction];

		CGPathAddArc(path, NULL, center.x, center.y, self.halfMoonRay, orientation.x, orientation.y, YES);

		CGContextAddPath(context, path);
		CGContextDrawPath(context, kCGPathStroke);

		CGPathRelease(path);
	}

	CGContextRestoreGState(context);
}

- (void)drawHalfMoon:(CGContextRef)context points:(NSArray*)points right:(BOOL)right
{
	// half moon
	CGPoint centerOfSegmentHalfMoon = [Geometry centerOfSegments:points offset:0.0f];

	GSegment middleSegment = [Geometry middleSegment:points];
	CGFloat angle = [Geometry angleOfLine:middleSegment.pointer direction:middleSegment.direction];

	CGMutablePathRef	 path = CGPathCreateMutable();

	CGPathAddArc(path, NULL, centerOfSegmentHalfMoon.x, centerOfSegmentHalfMoon.y, self.halfMoonRay, right ? angle + M_PI_2 : angle - M_PI_2, right ? angle - M_PI_2 : angle + M_PI_2, YES);

	CGContextAddPath(context, path);
	CGContextDrawPath(context, kCGPathFillStroke);

	CGPathRelease(path);
}

- (void)drawCenterSymbol:(CGContextRef)context symbol:(CenterSymbol)symbol points:(NSArray*)points
{
	CGContextSaveGState(context);

	CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);

	CGRect ball = CGRectNull;

	if (symbol == CenterSymbolBall)
	{
		CGPoint centerOfSegment = [Geometry centerOfSegments:points offset:0.0f];
		ball = [Geometry rectWithCenterIn:centerOfSegment width:(self.ballRay * 2) height:(self.ballRay * 2)];
	}
	else if (symbol == CenterSymbolBallAndRightHalfMoon)
	{
		[self drawHalfMoon:context points:points right:YES];

		CGPoint centerOfSegment = [Geometry centerOfSegments:points offset:self.ballOffsetByHalfMoon];
		ball = [Geometry rectWithCenterIn:centerOfSegment width:(self.ballRay * 2) height:(self.ballRay * 2)];
	}
	else if (symbol == CenterSymbolBallAndLeftHalfMoon)
	{
		[self drawHalfMoon:context points:points right:NO];

		CGPoint centerOfSegment = [Geometry centerOfSegments:points offset:-self.ballOffsetByHalfMoon];
		ball = [Geometry rectWithCenterIn:centerOfSegment width:(self.ballRay * 2) height:(self.ballRay * 2)];
	}

	if (!CGRectIsNull(ball))
	{
		CGContextFillEllipseInRect(context, ball);
		CGContextStrokeEllipseInRect(context, ball);
	}

	CGContextRestoreGState(context);
}

- (void)drawDiamondWithSymbol:(TerminalSymbol)symbol inContext:(CGContextRef)context pointer:(CGPoint)pointer direction:(CGPoint)direction
{
	CGFloat angle = [Geometry angleOfLine:pointer direction:direction];

	CGPoint end1 = CGPointMake(pointer.x + cosf(angle + kRelationElementArrowWingAngle) * self.arrowWingLenght, pointer.y + sinf(angle + kRelationElementArrowWingAngle) * self.arrowWingLenght);
	CGPoint end2 = CGPointMake(pointer.x + cosf(angle - kRelationElementArrowWingAngle) * self.arrowWingLenght, pointer.y + sinf(angle - kRelationElementArrowWingAngle) * self.arrowWingLenght);
	CGPoint end3 = CGPointMake(end1.x + cosf(angle - kRelationElementArrowWingAngle) * self.arrowWingLenght, end1.y + sinf(angle - kRelationElementArrowWingAngle) * self.arrowWingLenght);

	CGContextSaveGState(context);

	CGColorRef fillColor = (symbol == TerminalSymbolDiamond ? [UIColor whiteColor] : [UIColor blackColor]).CGColor;

	CGContextSetFillColorWithColor(context, fillColor);

	CGMutablePathRef	 path = CGPathCreateMutable();
	
	CGPathMoveToPoint(path, NULL, pointer.x, pointer.y);
	CGPathAddLineToPoint(path, NULL, end1.x, end1.y);
	CGPathAddLineToPoint(path, NULL, end3.x, end3.y);
	CGPathAddLineToPoint(path, NULL, end2.x, end2.y);
	CGPathCloseSubpath(path);

	CGContextAddPath(context, path);
	CGContextDrawPath(context, kCGPathFillStroke);

	CGPathRelease(path);
	
	CGContextRestoreGState(context);
}

- (void)drawCrossedSymbol:(CGContextRef)context pointer:(CGPoint)pointer direction:(CGPoint)direction
{
	CGFloat angle = [Geometry angleOfLine:pointer direction:direction];
	CGPoint center = [Geometry offsetOf:pointer direction:direction distance:self.crossDistance angle:0];

	CGFloat firstAngle = DegreesToRadians(40);
	CGFloat secondAngle = DegreesToRadians(140);

	CGPoint end1 = CGPointMake(center.x + cosf(angle + firstAngle) * self.crossSideLenght, center.y + sinf(angle + firstAngle) * self.crossSideLenght);
	CGPoint end2 = CGPointMake(center.x + cosf(angle + secondAngle) * self.crossSideLenght, center.y + sinf(angle + secondAngle) * self.crossSideLenght);
	CGPoint end3 = CGPointMake(center.x + cosf(angle - firstAngle) * self.crossSideLenght, center.y + sinf(angle - firstAngle) * self.crossSideLenght);
	CGPoint end4 = CGPointMake(center.x + cosf(angle - secondAngle) * self.crossSideLenght, center.y + sinf(angle - secondAngle) * self.crossSideLenght);

	CGContextSaveGState(context);

	CGMutablePathRef	 path = CGPathCreateMutable();

	CGPathMoveToPoint(path, NULL, end1.x, end1.y);
	CGPathAddLineToPoint(path, NULL, end4.x, end4.y);

	CGPathMoveToPoint(path, NULL, end2.x, end2.y);
	CGPathAddLineToPoint(path, NULL, end3.x, end3.y);

	CGContextAddPath(context, path);
	CGContextDrawPath(context, kCGPathFillStroke);

	CGPathRelease(path);

	CGContextRestoreGState(context);
}

- (void)drawDoubleLine:(LineType)lineType inContext:(CGContextRef)context withPoints:(NSArray *)points
{
	CGPoint p = [(NSValue*)points[0] CGPointValue];

	CGContextSaveGState(context);

	CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);

	for(int i = 1; i < points.count; ++i)
	{
		CGPoint nextPoint = [(NSValue*)points[i] CGPointValue];

		CGContextSetLineWidth(context, kElementViewLineWidth + 4);
		CGContextMoveToPoint(context, p.x, p.y);
		CGContextAddLineToPoint(context, nextPoint.x, nextPoint.y);

		p = nextPoint;
		
		CGContextReplacePathWithStrokedPath(context);
		CGContextSetLineWidth(context, kElementViewLineWidth);

		if (lineType == LineTypeDoubleDashed)
			CGContextSetLineDash(context, 0, dashedLengths, dashedLengthsSize);

		CGContextDrawPath(context, kCGPathFillStroke);
	}

	CGContextRestoreGState(context);
}

+ (void)drawDot:(CGContextRef)context x:(CGFloat)x y:(CGFloat)y
{
	CGContextAddEllipseInRect(context, CGRectMake(x - 2, y - 2, 4, 4));
	CGContextDrawPath(context, kCGPathFill);
}

- (void)drawAccessoryText:(TextLine *)textLine inContext:(CGContextRef)context p1:(CGPoint)p1 p2:(CGPoint)p2 xOffset:(CGFloat)xOffset yOffset:(CGFloat)yOffset
{
	CGFloat angle = atan2f(p2.y - p1.y, p2.x - p1.x);

	if (textLine != nil)
	{
		CGFloat factor = angle >= 0 ? 1 - sinf(angle) : 1 + cosf(angle - M_PI_2);
		CGFloat distance = fabs(self.accessorXOffset + xOffset + (textLine.textSize.width / 2) * factor);

		CGPoint m = [Geometry offsetOf:p1 direction:p2 distance:distance angle:0];

		CGFloat y = m.y + (angle >= 0 ? yOffset : -yOffset);

//		NSLog(@"a:%g; x: %g - y: %g", RadiansToDegrees(angle), m.x, y);

		[self drawText:textLine inContext:context centerAtX:m.x centerAtY:y];
	}
}

- (void)drawAccessoryText:(CGContextRef)context withPoints:(NSArray *)points
{
	if (points.count <= 1)
		return;

	CGPoint pa = [(NSValue*)points[0] CGPointValue];
	CGPoint pb = [(NSValue*)points[1] CGPointValue];

	CGFloat offset = 0;
	
	[self drawAccessoryText:self.m1 inContext:context p1:pa p2:pb xOffset:offset yOffset:self.accessorYMOffset];

	if (self.m1 != nil)
		offset += self.m1.textSize.width + self.accessorSpaceffset;
	
	[self drawAccessoryText:self.r1 inContext:context p1:pa p2:pb xOffset:offset yOffset:0];

	if (self.r1 != nil)
		offset += self.r1.textSize.width + self.accessorSpaceffset;

	[self drawAccessoryText:self.p1 inContext:context p1:pa p2:pb xOffset:offset yOffset:-self.fontSize];

	CGPoint pv = [(NSValue*)points[points.count - 2] CGPointValue];
	CGPoint pz = [(NSValue*)points[points.count - 1] CGPointValue];

	offset = 0;

	[self drawAccessoryText:self.m2 inContext:context p1:pz p2:pv xOffset:offset yOffset:self.accessorYMOffset];

	if (self.m2 != nil)
		offset += self.m2.textSize.width + self.accessorSpaceffset;

	[self drawAccessoryText:self.r2 inContext:context p1:pz p2:pv xOffset:offset yOffset:0];

	if (self.r2 != nil)
		offset += self.r2.textSize.width + self.accessorSpaceffset;

	[self drawAccessoryText:self.p2 inContext:context p1:pz p2:pv xOffset:offset yOffset:-self.fontSize];
}

@end
