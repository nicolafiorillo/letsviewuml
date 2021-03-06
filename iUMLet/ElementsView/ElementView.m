//
//  ElementView.m
//  Let's view UML
//
//  Created by Nicola Fiorillo on 6/16/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import "ElementView.h"
#import "Element.h"
#import "NSString+NSStringLib.h"
#import <QuartzCore/QuartzCore.h>
#import "Const.h"

static CGFloat const kElementViewBackgroundAlpha		= 0.55f;

static CGFloat const kElementViewArrowDim				= 8.0f;
static CGFloat const kElementViewArrowTextDistance		= 3.0f;

CGFloat const kElementViewLineWidth						= 1.0f;

@interface ElementView()

@property (nonatomic)NSInteger zoomLevel;

@property (strong, nonatomic)UIColor * backgroundColor;
@property (strong, nonatomic)UIColor * foregroundColor;

@property (strong, nonatomic, readwrite)NSMutableArray * additionalAttributesPoints;
@property (strong, nonatomic)NSMutableArray * text;

@property (nonatomic)CGFloat arrowDim;
@property (nonatomic)CGFloat arrowTextDistance;

@end

@implementation ElementView

+(Class)layerClass
{
	return [CATiledLayer class];
}

- (UIColor *)backgroundColor
{
	if (!_backgroundColor)
		_backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:kElementViewBackgroundAlpha];

	return _backgroundColor;
}

- (UIColor *)foregroundColor
{
	if (!_foregroundColor)
		_foregroundColor = [UIColor blackColor];

	return _foregroundColor;
}

-(NSString *)lt
{
	if (_lt == nil)
		_lt	 = @"";

	return _lt;
}

- (NSMutableArray *)text
{
	if (_text == nil)
		_text = [[NSMutableArray alloc] init];

	return _text;
}

- (id)initWithElement:(Element *)element fontGeometry:(FontGeometry *)fontGeometry zoom:(NSInteger)zoom
{
    self = [super initWithFrame:element.coordinates];

	if (self) {

		self.element = element;
		self.zoomLevel = zoom;
		self.fontGeometry = fontGeometry;

		CATiledLayer * thisTiledLayer = (CATiledLayer *)self.layer;
		thisTiledLayer.levelsOfDetail = kLevelsOfDetail;
		thisTiledLayer.levelsOfDetailBias = kLevelsOfDetailBias;
		
		self.opaque = NO;
		
		self.boundingRect = CGRectIntegral(self.bounds);

		self.additionalAttributesPoints = [ElementView splitAsPoints:self.element.additional_attributes];

		[self readPanelAttributes];

		self.arrowDim = kElementViewArrowDim * self.scaleFactor;
		self.arrowTextDistance = kElementViewArrowTextDistance * self.scaleFactor;
    }

    return self;
}

- (void)readPanelAttributes
{
	NSString * input = self.element.panel_attributes;

	if (input.length > 0)
	{
		NSArray * lines = [input componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];

		for(NSString * line in lines)
		{
			if (line.length > 0)
			{
				if ([line isLt])
					self.lt = [line substringFromIndex:3];
				else if ([line isBt])
					self.bt = [line substringFromIndex:3];
				else if ([line isActive])
					self.activeClass = YES;
				else if ([line isM1])
					self.m1 = [TextLine text:[line substringFromIndex:3] inRect:self.boundingRect.size withFont:self.fontGeometry.font andStyle:FontStyleNone];
				else if ([line isM2])
					self.m2 = [TextLine text:[line substringFromIndex:3] inRect:self.boundingRect.size withFont:self.fontGeometry.font andStyle:FontStyleNone];
				else if ([line isR1])
					self.r1 = [TextLine text:[line substringFromIndex:3] inRect:self.boundingRect.size withFont:self.fontGeometry.font andStyle:FontStyleNone];
				else if ([line isR2])
					self.r2 = [TextLine text:[line substringFromIndex:3] inRect:self.boundingRect.size withFont:self.fontGeometry.font andStyle:FontStyleNone];
				else if ([line isQ1])
					self.q1 = [TextLine text:[line substringFromIndex:3] inRect:self.boundingRect.size withFont:self.fontGeometry.font andStyle:FontStyleNone];
				else if ([line isQ2])
					self.q2 = [TextLine text:[line substringFromIndex:3] inRect:self.boundingRect.size withFont:self.fontGeometry.font andStyle:FontStyleNone];
				else if ([line isP1])
					self.p1 = [TextLine text:[line substringFromIndex:3] inRect:self.boundingRect.size withFont:self.fontGeometry.font andStyle:FontStyleNone];
				else if ([line isP2])
					self.p2 = [TextLine text:[line substringFromIndex:3] inRect:self.boundingRect.size withFont:self.fontGeometry.font andStyle:FontStyleNone];
				else if ([line isLine])
					[self.text addObject:[TextLine separator]];
				else if ([line isDashedLine])
					[self.text addObject:[TextLine dashedSeparator]];
				else if ([line isForegroundColor])
					self.foregroundColor = [[line substringFromIndex:3] asColorWithAlpha:1.0];
				else if ([line isBackgroundColor])
					self.backgroundColor = [[line substringFromIndex:3] asColorWithAlpha:kElementViewBackgroundAlpha];
				else if ([line isNotWhitespaces])
				{
					FontStyle style = FontStyleNone;

					BOOL cleaned = NO;
					NSString * cleanedLine = [[NSString alloc ] initWithString:line];

					while (!cleaned)
					{
						cleaned = YES;

						if ([cleanedLine isDecoratedWithSymbol:'*'])
						{
							style += FontStyleBold;
							cleaned = NO;
							cleanedLine = [cleanedLine stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"*"]];
						}
						else if ([cleanedLine isDecoratedWithSymbol:'/'])
						{
							style += FontStyleItalic;
							cleaned = NO;
							cleanedLine = [cleanedLine stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"//"]];
						}
						else if ([cleanedLine isDecoratedWithSymbol:'_'])
						{
							style += FontStyleUnderscore;
							cleaned = NO;
							cleanedLine = [cleanedLine stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"_"]];
						}
					}

					[self.text addObject:[TextLine text:cleanedLine inRect:self.boundingRect.size withFont:self.fontGeometry.font andStyle:style]];
				}
			}
		}
	}
}

- (CGFloat)scaleFactor
{
	return self.zoomLevel / 10.0;
}

+ (NSMutableArray *)splitAsPoints:(NSString *)coordinates
{
	NSMutableArray * points = [[NSMutableArray alloc] initWithArray:@[]];

	if (coordinates.length != 0)
	{
		NSArray * nums = [coordinates componentsSeparatedByString:@";"];
		for (int i = 0; i < [nums count]; i = i + 2)
		{
			NSString * x = nums[i];
			NSString * y = nums[i + 1];

			[points addObject:[NSValue valueWithCGPoint:CGPointMake([x floatValue] , [y floatValue])]];
		}
	}
	
	return points;
}

- (const char *)fontNameByStyle:(FontStyle)style
{
	const char * fontName = [self.fontGeometry.font.fontName UTF8String];

	if ((style & FontStyleBold) && (style & FontStyleItalic))
		fontName = [self.fontGeometry.fontBoldItalic.fontName UTF8String];
	else if (style & FontStyleBold)
		fontName = [self.fontGeometry.fontBold.fontName UTF8String];
	else if (style & FontStyleItalic)
		fontName = [self.fontGeometry.fontItalic.fontName UTF8String];

	return fontName;
}

- (void)drawArrow:(CGContextRef)context rightArrow:(BOOL)right atX:(CGFloat)x atY:(CGFloat)y
{
	CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);

	x += right ? self.arrowTextDistance : -self.arrowTextDistance;

	CGMutablePathRef	 path = CGPathCreateMutable();

	CGPathMoveToPoint(path, NULL, x, y);
	CGPathAddLineToPoint(path, NULL, x, y - self.arrowDim);

	CGPathAddLineToPoint(path, NULL, x + (right ? self.arrowDim : -self.arrowDim), y - (self.arrowDim / 2));

	CGPathCloseSubpath(path);

	CGContextAddPath(context, path);
	CGContextDrawPath(context, kCGPathFill);

	CGPathRelease(path);
}

- (void)drawText:(TextLine *)textLine inContext:(CGContextRef)context atX:(CGFloat)x atY:(CGFloat)y
{
	NSString * fontName = [NSString stringWithFormat:@"%s", [self fontNameByStyle:textLine.fontStyle]];

    CGAffineTransform matrix = CGAffineTransformMakeScale(1.0, -1.0);

    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)fontName, self.fontGeometry.fontSize, &matrix);
    NSDictionary * attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:(id)CFBridgingRelease(fontRef), (NSString*)kCTFontAttributeName, (id)[self.foregroundColor CGColor], kCTForegroundColorAttributeName, nil];
    NSString * text = [NSString stringWithFormat:@"%s", [textLine printable]];

    NSAttributedString * attrString = [[NSAttributedString alloc]initWithString:text attributes:attributesDictionary];
    CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)attrString);

	CGContextSetTextDrawingMode(context, kCGTextFill);
	CGContextSetShouldAntialias(context, true);

    CGContextSetTextPosition(context, x, y);
    CTLineDraw(line, context);
    CFRelease(line);

	if (textLine.hasLeftArrow)
		[self drawArrow:context rightArrow:NO atX:x atY:y];

	if (textLine.hasRightArrow)
		[self drawArrow:context rightArrow:YES atX: x + textLine.textSize.width atY:y];

	if (textLine.fontStyle & FontStyleUnderscore)
	{
		CGFloat space = y + self.fontGeometry.underscoreSpace;

		CGContextMoveToPoint(context, x, space);
		CGContextAddLineToPoint(context, x + textLine.textSize.width, space);
		CGContextStrokePath(context);
	}
}

- (void)drawText:(TextLine *)textLine inContext:(CGContextRef)context centerAtPoint:(CGPoint)point
{
	CGFloat origX = point.x - (textLine.textSize.width / 2);
	CGFloat origY = point.y + (textLine.textSize.height / 2) - (textLine.textSize.height - self.fontGeometry.fontSize);

	[self drawText:textLine inContext:context atX:origX atY:origY];
}

- (void)drawText:(TextLine *)textLine inContext:(CGContextRef)context centerAtX:(CGFloat)x centerAtY:(CGFloat)y
{
	CGFloat origX = x - (textLine.textSize.width / 2);
	CGFloat origY = y + (textLine.textSize.height / 2);
	
	[self drawText:textLine inContext:context atX:origX atY:origY];
}

- (void)drawTextInContext:(CGContextRef)context centerVertically:(BOOL)centerVertically centerHorizontally:(BOOL)centerHorizontally firstLineAt:(CGFloat)lineAt
{
	int yOffset = 0;
	if (lineAt > 0)
		yOffset = lineAt - self.fontGeometry.fontSize - self.fontGeometry.fontFromBottomSpace;

	CGContextSaveGState(context);
	CGContextSetStrokeColorWithColor(context, [self.foregroundColor CGColor]);
	CGContextSetFillColorWithColor(context, [self.foregroundColor CGColor]);

	NSMutableArray * textLines = self.text;
	if (textLines == nil)
		NSLog(@"Error: textLines is null");
	else
	{
		for (TextLine * textLine in textLines)
		{
			if (textLine.isSeparator)
			{
				yOffset += self.fontGeometry.fontSeparatorSpace;
				
				CGContextMoveToPoint(context, 0, yOffset);
				CGContextAddLineToPoint(context, CGRectGetWidth(self.boundingRect), yOffset);
				CGContextStrokePath(context);

				centerHorizontally = NO;
			}
			else
			{
				float x = centerHorizontally ? (CGRectGetWidth(self.boundingRect) - textLine.textSize.width) / 2 : self.fontGeometry.fontLeftSpace;
				float y = centerVertically ? self.fontGeometry.fontSize + ((CGRectGetHeight(self.boundingRect) - textLine.textSize.height) / 2) : self.fontGeometry.fontSize + self.fontGeometry.fontUpperSpace;

				y += yOffset;
				yOffset = y;

				[self drawText:textLine inContext:context atX:x atY:y];
			}
		}	// malloc_error_break
	}
	
	CGContextRestoreGState(context);
}

- (void)drawTextVerticallyInContext:(CGContextRef)context
{
	[self drawTextInContext:context centerVertically:YES  centerHorizontally:YES firstLineAt:0.0];
}

- (void)drawLeftJustifiedInContext:(CGContextRef)context
{
	[self drawTextInContext:context centerVertically:NO centerHorizontally:NO firstLineAt:0.0];
}

- (void)drawTextInContext:(CGContextRef)context firstLineAt:(CGFloat)offset
{
	[self drawTextInContext:context centerVertically:NO  centerHorizontally:YES firstLineAt:offset];
}

- (void)drawRect:(CGRect)rect
{
}

@end
