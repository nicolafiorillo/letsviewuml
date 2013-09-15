//
//  Grid.h
//  Let's view UML
//
//  Created by Nicola Fiorillo on 7/20/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Grid : NSObject

+ (void)drawGridInContext:(CGContextRef)context inRect:(CGRect)rect;
+ (UIImage *)gridForRect:(CGRect)rect scale:(CGFloat)scale;

@end
