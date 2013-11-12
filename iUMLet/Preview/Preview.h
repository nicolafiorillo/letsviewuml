//
//  Preview.h
//  Let's view UML
//
//  Created by Nicola Fiorillo on 7/29/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Canvas.h"

@interface Preview : NSObject

+ (void)saveForPreview:(Canvas *)canvas image:(UIImage *)image;
+ (UIImage *)loadPreview:(Canvas *)canvas;

@end
