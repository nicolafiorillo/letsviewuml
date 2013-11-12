//
//  Canvas.h
//  Let's view UML
//
//  Created by Nicola Fiorillo on 6/5/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Canvas : NSObject

@property (strong, nonatomic, readonly)NSString * name;
@property (strong, nonatomic, readonly)NSString * fullPath;
@property (strong, nonatomic, readonly)NSString * source;

@property (nonatomic, getter = isLoaded)BOOL loaded;

@property (nonatomic)NSInteger zoomLevel;
@property (strong, nonatomic)NSString * program;
@property (strong, nonatomic)NSString * programVersion;

@property (strong, nonatomic)NSMutableArray * elements;

@property (nonatomic)CGRect dimension;
@property (nonatomic)CGPoint topLeftElementOrigin;

- (id)initWithFullPath:(NSString *)path andSource:(NSString *)source;

@end
