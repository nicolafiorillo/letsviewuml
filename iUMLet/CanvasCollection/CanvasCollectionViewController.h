//
//  CanvasCollectionViewController.h
//  Let's view UML
//
//  Created by Nicola Fiorillo on 7/16/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Repository.h"

@interface CanvasCollectionViewController : UICollectionViewController

@property (strong, nonatomic)Repository * canvasRepository;

@end

