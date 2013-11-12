//
//  FileSystem.m
//  Let's view UML
//
//  Created by Nicola Fiorillo on 9/17/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import "FileSystem.h"

@implementation FileSystem

+ (NSString *)deviceRoot
{
	NSSearchPathDirectory source = NSCachesDirectory;

#if TARGET_IPHONE_SIMULATOR
	source = NSDocumentDirectory;
#endif

	NSArray * paths = NSSearchPathForDirectoriesInDomains(source, NSUserDomainMask, YES);
	NSString *root = [paths objectAtIndex:0];

	return root;
}

@end
