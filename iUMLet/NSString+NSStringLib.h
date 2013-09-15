//
//  NSString+NSStringLib.h
//  Let's view UML
//
//  Created by Nicola Fiorillo on 6/28/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSStringLib)

- (BOOL)isDecoratedWithSymbol:(unichar)symbol;
- (BOOL)isBackgroundColor;
- (BOOL)isForegroundColor;
- (BOOL)isLine;
- (BOOL)isDashedLine;
- (BOOL)isNotWhitespaces;
- (UIColor *)asColorWithAlpha:(CGFloat)alpha;

- (BOOL)beginWithString:(NSString *)str;
- (BOOL)endWithString:(NSString *)str;

- (BOOL)isLt;
- (BOOL)isBt;
- (BOOL)isActive;
- (BOOL)isM1;
- (BOOL)isM2;
- (BOOL)isR1;
- (BOOL)isR2;
- (BOOL)isQ1;
- (BOOL)isQ2;
- (BOOL)isP1;
- (BOOL)isP2;

- (const char *)replaceAngulars;

@end
