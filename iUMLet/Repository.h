//
//  Repository.h
//  Let's view UML
//
//  Created by Nicola Fiorillo on 7/16/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Canvas.h"

@interface Repository : NSObject

@property(nonatomic, strong)NSString * name;

@property(nonatomic, readonly)NSInteger numberOfItems;
@property(nonatomic, strong)NSString * rootPath;

- (id)itemAtIndex:(NSInteger)index;
- (Canvas *)loadCanvasAtIndex:(NSInteger)index;

@end
