//
//  ElementViewFactory.h
//  Let's view UML
//
//  Created by Nicola Fiorillo on 7/5/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ElementView.h"

@interface ElementViewFactory : NSObject

+ (ElementView *)createWithElement:(Element *)element andZoomLevel:(NSInteger)zoomLevel;

@end
