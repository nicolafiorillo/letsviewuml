//
//  UIViewController+BackgrounderViewController.m
//  Let's view UML
//
//  Created by Nicola Fiorillo on 9/3/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import "UIViewController+BackgrounderViewController.h"

@implementation UIViewController (BackgrounderViewController)

- (NSString *)backgroudByOrientation
{
	NSString * backgroundFile = @"Default-Portrait";
	UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight)
		backgroundFile = @"Default-Landscape";

	return backgroundFile;
}

@end
