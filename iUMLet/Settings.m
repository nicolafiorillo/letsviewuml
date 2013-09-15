//
//  Settings.m
//  Let's view UML
//
//  Created by Nicola Fiorillo on 9/5/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import "Settings.h"

static Settings * _settings = nil;
static NSString * kGridKey = @"showgrid";

@implementation Settings

+ (Settings *)getInstance
{
	if (!_settings)
		_settings = [Settings new];

	return _settings;
}

- (BOOL)showGrid
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if (![defaults objectForKey:kGridKey])
		return YES;
	
	return [defaults boolForKey:kGridKey];
}

- (void)setShowGrid:(BOOL)showGrid
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:showGrid forKey:kGridKey];

	[defaults synchronize];
}

@end
