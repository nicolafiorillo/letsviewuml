//
//  FontGeometry.h
//  Let's view UML
//
//  Created by Nicola Fiorillo on 19/12/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FontGeometry : NSObject

- (id)initWithZoom:(NSInteger)zoom;

@property (strong, nonatomic)UIFont * font;
@property (strong, nonatomic)UIFont * fontBold;
@property (strong, nonatomic)UIFont * fontItalic;
@property (strong, nonatomic)UIFont * fontBoldItalic;

@property (nonatomic)CGFloat fontSize;
@property (nonatomic)CGFloat fontUpperSpace;
@property (nonatomic)CGFloat fontFromBottomSpace;
@property (nonatomic)CGFloat fontSeparatorSpace;
@property (nonatomic)CGFloat fontLeftSpace;
@property (nonatomic)CGFloat underscoreSpace;

@end
