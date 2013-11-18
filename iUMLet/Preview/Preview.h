//
//  Preview.h
//  Let's view UML
//
//  Created by Nicola Fiorillo on 18/11/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Canvas.h"

@interface Preview : NSObject

- (void)saveCanvas:(Canvas *)canvas asImage:(UIImage *)image;
- (UIImage *)loadForCanvas:(Canvas *)canvas;

@end
