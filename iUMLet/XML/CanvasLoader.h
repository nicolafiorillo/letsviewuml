//
//  CanvasLoader.h
//  Let's view UML
//
//  Created by Nicola Fiorillo on 6/5/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Canvas.h"

@interface CanvasLoader : NSObject

+ (void)loadFromFile:(Canvas *)canvas;

@end
