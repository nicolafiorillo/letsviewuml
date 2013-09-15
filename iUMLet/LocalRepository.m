//
//  LocalRepository.m
//  Let's view UML
//
//  Created by Nicola Fiorillo on 8/14/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import "LocalRepository.h"

@implementation LocalRepository

+ (LocalRepository *)createLocalRepository
{
	NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	LocalRepository * localRepository = [[LocalRepository new] initWithRootPath:[paths objectAtIndex:0]];

	return localRepository;
}

- (id)initWithRootPath:(NSString*)rootPath
{
	self = [super init];
	if (self)
	{
		self.rootPath = rootPath;
		self.name = [rootPath.pathComponents lastObject];
	}
	
	return self;
}

- (NSMutableArray *)loadAvailableItems
{
	NSMutableArray * items = [NSMutableArray array];

	NSError * error;
    NSArray * files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.rootPath error:&error];

	if (files != nil)
	{
		for (NSString *file in files)
		{
			NSString * fullPath = [self.rootPath stringByAppendingPathComponent:file];
			NSDictionary * fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:fullPath error:&error];

			if (fileAttributes.fileType == NSFileTypeRegular && [file.pathExtension.uppercaseString isEqualToString:@"UXF"])
				[items addObject:[[Canvas alloc] initWithFullPath:fullPath andSource:@"LOCAL"]];
			else if (fileAttributes[NSFileType] == NSFileTypeDirectory)
				[items addObject:[[LocalRepository new] initWithRootPath:fullPath]];
		}
	}
	else
        NSLog(@"Error reading contents of documents directory: %@", [error localizedDescription]);

	return items;
}

@end
