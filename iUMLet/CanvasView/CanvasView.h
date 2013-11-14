//
//  CanvasView.h
//  Let's view UML
//
//  Created by Nicola Fiorillo on 6/16/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Canvas.h"

@interface CanvasView : UIView

@property (strong, nonatomic)Canvas *canvas;

- (id)initWithCanvas:(Canvas *)canvas;

@end
