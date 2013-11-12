//
//  ElementView.h
//  Let's view UML
//
//  Created by Nicola Fiorillo on 6/16/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import "Element.h"
#import "TextLine.h"

extern CGFloat const kElementViewLineWidth;

static CGFloat const dashedLengths[]	 = { 10, 4 };
static size_t const dashedLengthsSize = sizeof(dashedLengths) / sizeof(float);

@interface ElementView : UIView

- (id)initWithElement:(Element *)element andZoom:(NSInteger)zoom;

@property (nonatomic)CGRect boundingRect;

@property (nonatomic)CGFloat fontSize;
@property (nonatomic)CGFloat fontUpperSpace;
@property (nonatomic)CGFloat fontFromBottomSpace;
@property (nonatomic)CGFloat fontSeparatorSpace;
@property (nonatomic)CGFloat fontLeftSpace;
@property (nonatomic)CGFloat underscoreSpace;

@property (strong, nonatomic)Element * element;
@property (nonatomic)NSInteger zoomLevel;
@property (nonatomic)CGFloat scaleFactor;
@property	(strong, nonatomic, readonly)NSMutableArray * additionalAttributesPoints;
@property	(strong, nonatomic, readonly)NSMutableArray * text;
@property	(strong, nonatomic, readonly)UIColor * backgroundColor;
@property	(strong, nonatomic, readonly)UIColor * foregroundColor;

@property (strong, nonatomic)NSString * lt;
@property (strong, nonatomic)NSString * bt;
@property (strong, nonatomic)TextLine * m1;
@property (strong, nonatomic)TextLine * m2;
@property (strong, nonatomic)TextLine * r1;
@property (strong, nonatomic)TextLine * r2;
@property (strong, nonatomic)TextLine * q1;
@property (strong, nonatomic)TextLine * q2;
@property (strong, nonatomic)TextLine * p1;
@property (strong, nonatomic)TextLine * p2;
@property (nonatomic)BOOL activeClass;

- (void)drawTextVerticallyInContext:(CGContextRef)context;
- (void)drawTextInContext:(CGContextRef)context firstLineAt:(CGFloat)offset;
- (void)drawLeftJustifiedInContext:(CGContextRef)context;

- (void)drawText:(TextLine *)textLine inContext:(CGContextRef)context atX:(CGFloat)x atY:(CGFloat)y;
- (void)drawText:(TextLine *)textLine inContext:(CGContextRef)context centerAtX:(CGFloat)x centerAtY:(CGFloat)y;
- (void)drawText:(TextLine *)textLine inContext:(CGContextRef)context centerAtPoint:(CGPoint)point;

- (const char *)fontNameByStyle:(FontStyle)style;

@end
