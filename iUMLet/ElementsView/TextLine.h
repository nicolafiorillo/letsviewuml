//
//  TextLine.h
//  Let's view UML
//
//  Created by Nicola Fiorillo on 6/27/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, FontStyle)
{
	FontStyleNone			= 0,
	FontStyleBold			= 1 << 0,
	FontStyleItalic			= 1 << 1,
	FontStyleUnderscore		= 1 << 2
};

@interface TextLine : NSObject

@property (strong, nonatomic, readonly)NSString * text;
@property (nonatomic, readonly)CGSize textSize;
@property (nonatomic)CGPoint textPosition;
@property (nonatomic)CGRect textFixedPosition;
@property (nonatomic, readonly)BOOL isSeparator;
@property (nonatomic, readonly)BOOL isDashedSeparator;
@property (nonatomic, readonly)FontStyle fontStyle;

@property (nonatomic, readonly)BOOL hasLeftArrow;
@property (nonatomic, readonly)BOOL hasRightArrow;

+ (TextLine *)separator;
+ (TextLine *)dashedSeparator;
+ (TextLine *)text:(NSString *)text inRect:(CGSize)size withFont:(UIFont *)font andStyle:(FontStyle)fontStyle;

- (const char *)printable;

@end
