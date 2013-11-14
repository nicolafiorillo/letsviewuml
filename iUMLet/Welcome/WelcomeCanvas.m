//
//  WelcomeCanvas.m
//  Let's view UML
//
//  Created by Nicola Fiorillo on 9/12/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import "WelcomeCanvas.h"
#import "Settings.h"
#import "FileSystem.h"
#import "Grid.h"

static WelcomeCanvas * _welcomeCanvas = nil;
static NSString * kWelcomeFileName = @"Welcome";
static NSString * kWelcomeFileExtension = @"uxf";

@implementation WelcomeCanvas

+ (WelcomeCanvas *)getInstance
{
	if (!_welcomeCanvas)
		_welcomeCanvas = [WelcomeCanvas new];

	return _welcomeCanvas;
}

- (void)generate
{
//	generate background images
//	[Grid flushBackgroundGridInFile:@"Launch-Portrait" rect:CGRectMake(0, 0, 768, 1024) scale:1.0f];
//	[Grid flushBackgroundGridInFile:@"Launch-Landscape" rect:CGRectMake(0, 0, 1024, 768) scale:1.0f];
//	[Grid flushBackgroundGridInFile:@"Launch-Portrait@2x" rect:CGRectMake(0, 0, 768, 1024) scale:2.0f];
//	[Grid flushBackgroundGridInFile:@"Launch-Landscape@2x" rect:CGRectMake(0, 0, 1024, 768) scale:2.0f];
    
	NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
	if ([[Settings getInstance] firstTimeForVersion:version])
		[self addWelcomeCanvas];
}

- (void)addWelcomeCanvas
{
	NSString *welcomeFileName = [[NSBundle mainBundle] pathForResource:kWelcomeFileName ofType:kWelcomeFileExtension];
	NSData *welcomeFileData = [NSData dataWithContentsOfFile:welcomeFileName];
	if (welcomeFileData)
	{
		NSString * root = [FileSystem deviceRoot];

		NSString * localFilePathName = [root stringByAppendingPathComponent:kWelcomeFileName];
		localFilePathName = [localFilePathName stringByAppendingPathExtension:kWelcomeFileExtension];

		NSFileManager * manager = [NSFileManager defaultManager];
		if (manager != nil)
			[welcomeFileData writeToFile:localFilePathName atomically:NO];
	}
}

@end
