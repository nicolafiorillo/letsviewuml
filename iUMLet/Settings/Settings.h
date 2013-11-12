//
//  Settings.h
//  Let's view UML
//
//  Created by Nicola Fiorillo on 9/5/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject

@property (nonatomic)BOOL showGrid;

- (BOOL)firstTimeForVersion:(NSString *)version;

+ (Settings *)getInstance;

@end

