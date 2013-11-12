//
//  NSString+NSStringLib.m
//  Let's view UML
//
//  Created by Nicola Fiorillo on 6/28/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import "NSString+NSStringLib.h"

@implementation NSString (NSStringLib)

- (BOOL)isDecoratedWithSymbol:(unichar)symbol
{
	return self.length > 1 && [self characterAtIndex:0] == symbol && [self characterAtIndex:self.length - 1] == symbol;
}

- (BOOL)isLt
{
	return [self isAccessor:@"lt="];
}

- (BOOL)isBt
{
	return [self isAccessor:@"bt="];
}

- (BOOL)isActive
{
	return [self isEqualToString:@"{active}"];
}

- (BOOL)isM1
{
	return [self isAccessor:@"m1="];
}

- (BOOL)isM2
{
	return [self isAccessor:@"m2="];
}

- (BOOL)isR1
{
	return [self isAccessor:@"r1="];
}

- (BOOL)isR2
{
	return [self isAccessor:@"r2="];
}

- (BOOL)isQ1
{
	return [self isAccessor:@"q1="];
}

- (BOOL)isQ2
{
	return [self isAccessor:@"q2="];
}

- (BOOL)isP1
{
	return [self isAccessor:@"p1="];
}

- (BOOL)isP2
{
	return [self isAccessor:@"p2="];
}

- (BOOL)isAccessor:(NSString *)accessor
{
	return self.length > 2 && [self rangeOfString:accessor options:0 range:NSMakeRange(0, 3)].location != NSNotFound;
}

- (BOOL)beginWithString:(NSString *)str
{
	return self.length >= str.length && [self rangeOfString:str options:0 range:NSMakeRange(0, str.length)].location != NSNotFound;
}

- (BOOL)endWithString:(NSString *)str
{
	return self.length >= str.length && [self rangeOfString:str options:0 range:NSMakeRange(self.length - str.length, str.length)].location != NSNotFound;
}

- (BOOL)isBackgroundColor
{
	return self.length > 2 && [self rangeOfString:@"bg=" options:0 range:NSMakeRange(0, 3)].location != NSNotFound;
}

- (BOOL)isForegroundColor
{
	return self.length > 2 && [self rangeOfString:@"fg=" options:0 range:NSMakeRange(0, 3)].location != NSNotFound;
}

- (BOOL)isLine
{
	return [self isEqualToString:@"--"];
}

- (BOOL)isDashedLine
{
	return [self isEqualToString:@"-."];
}

- (BOOL)isNotWhitespaces
{
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]].length > 0;
}

- (UIColor *)asColorFromRGBWithAlpha:(CGFloat)alpha
{
	//#3c7a00
	unsigned rgbValue = 0;

	NSScanner *scanner = [NSScanner scannerWithString:self];
	[scanner setScanLocation:1]; // bypass '#' character
	[scanner scanHexInt:&rgbValue];
	return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:alpha];
}

- (UIColor *)asColorWithAlpha:(CGFloat)alpha
{
	const NSDictionary * colorMap = @{
												@"red": [UIColor redColor],
												@"green": [UIColor greenColor],
												@"blue": [UIColor blueColor],
												@"yellow": [UIColor yellowColor],
												@"orange": [UIColor orangeColor],
												@"magenta": [UIColor magentaColor],
												@"cyan": [UIColor cyanColor],
												@"white": [UIColor whiteColor],
												@"light_gray": [UIColor lightGrayColor],
												@"gray": [UIColor grayColor],
												@"dark_gray": [UIColor darkGrayColor],
												@"black": [UIColor blackColor],
												@"pink": [@"#FFA4FF" asColorFromRGBWithAlpha:alpha]
											};

	UIColor * c = [colorMap objectForKey:self];
	return c != nil ? [c colorWithAlphaComponent:alpha] : [self asColorFromRGBWithAlpha:alpha];
}

void replace(char * o_string, char * s_string, char * r_string)
{
	char buffer[4096];
	char * ch;

	if(!(ch = strstr(o_string, s_string)))
		return;

	strncpy(buffer, o_string, ch-o_string);

	buffer[ch-o_string] = 0;

	sprintf(buffer+(ch - o_string), "%s%s", r_string, ch + strlen(s_string));

	o_string[0] = 0;
	strcpy(o_string, buffer);

	return replace(o_string, s_string, r_string);
}

- (const char *)replaceAngulars
{
	char abStr[2] = {199, 0};
	char bbStr[2] = {200, 0};

	char * cleaned = (char *)[self UTF8String];
	replace(cleaned, "<<", abStr);
	replace(cleaned, ">>", bbStr);

	return cleaned;
}

@end
