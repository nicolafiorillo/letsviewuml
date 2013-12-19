//
//  LocalRepository.m
//  Let's view UML
//
//  Created by Nicola Fiorillo on 8/14/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import "LocalRepository.h"
#import "Settings.h"

static NSString * kWelcomeFileName = @"Welcome";
static NSString * kWelcomeFileExtension = @"uxf";

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
		[self generateWelcomeCanvas];
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

-(void)generateWelcomeCanvas
{
	//	generate background images
	//	[Grid flushBackgroundGridInFile:@"Launch-Portrait" rect:CGRectMake(0, 0, 768, 1024) scale:1.0f];
	//	[Grid flushBackgroundGridInFile:@"Launch-Landscape" rect:CGRectMake(0, 0, 1024, 768) scale:1.0f];
	//	[Grid flushBackgroundGridInFile:@"Launch-Portrait@2x" rect:CGRectMake(0, 0, 768, 1024) scale:2.0f];
	//	[Grid flushBackgroundGridInFile:@"Launch-Landscape@2x" rect:CGRectMake(0, 0, 1024, 768) scale:2.0f];
    
	//	log available fonts
	[self logFontsToFile:@"Font.txt"];

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
		NSString * localFilePathName = [self.rootPath stringByAppendingPathComponent:kWelcomeFileName];
		localFilePathName = [localFilePathName stringByAppendingPathExtension:kWelcomeFileExtension];
		
		NSFileManager * manager = [NSFileManager defaultManager];
		if (manager != nil)
			[welcomeFileData writeToFile:localFilePathName atomically:NO];
	}
}

- (void)logFontsToFile:(NSString*) fileName
{
	NSString * content = @"";
	
	NSArray * familyNames = [[UIFont familyNames] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	for (NSString * familyName in familyNames)
	{
		content = [content stringByAppendingFormat:@"\r%@\r", familyName];
		NSArray * fonts = [UIFont fontNamesForFamilyName:familyName];
		for (NSString * font in fonts)
			content = [content stringByAppendingFormat:@"    %@\r", font];
	}
	
	NSFileManager * manager = [NSFileManager defaultManager];
	if (manager != nil)
	{
		NSString * localFilePathName = [self.rootPath stringByAppendingPathComponent:fileName];
		[manager createFileAtPath:localFilePathName contents:[content dataUsingEncoding:NSUnicodeStringEncoding] attributes:nil];
	}
}

@end
