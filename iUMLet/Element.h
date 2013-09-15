//
//  Element.h
//  Let's view UML
//
//  Created by Nicola Fiorillo on 6/6/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Element : NSObject

@property (strong, nonatomic)NSString * type;
@property (strong, nonatomic)NSString * panel_attributes;
@property (strong, nonatomic)NSString * additional_attributes;
@property (nonatomic)CGRect coordinates;

@end
