//
//  CanvasViewController.h
//  Let's view UML
//
//  Created by Nicola Fiorillo on 6/5/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Canvas.h"

@protocol CanvasViewControllerDelegate;

@interface CanvasViewController : UIViewController

@property	(strong, nonatomic)Canvas *canvas;
@property (nonatomic)NSIndexPath * indexPath;

@property (weak, nonatomic)id<CanvasViewControllerDelegate> delegate;

@end

@protocol CanvasViewControllerDelegate <NSObject>

- (void)didDismiss:(CanvasViewController *)canvasViewController;

@end
