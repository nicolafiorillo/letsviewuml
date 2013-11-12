//
//  Preview.m
//  Let's view UML
//
//  Created by Nicola Fiorillo on 7/29/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import "Preview.h"
#import "FileSystem.h"

@implementation Preview

+ (void)saveForPreview:(Canvas *)canvas image:(UIImage *)image
{
	NSString * root = [FileSystem deviceRoot];

	NSString * path = [root stringByAppendingPathComponent:[canvas.source stringByAppendingPathComponent:root]];
	NSString * filepathName = [path stringByAppendingPathComponent:canvas.name];
	
	filepathName = [filepathName stringByAppendingPathExtension:@"png"];

	NSFileManager * manager = [NSFileManager defaultManager];
	if (manager != nil)
	{
		NSError * error;
		[manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];

		[UIImagePNGRepresentation(image) writeToFile:filepathName atomically:YES];
	}
}

+ (UIImage *)loadPreview:(Canvas *)canvas
{
	NSString * root = [FileSystem deviceRoot];

	NSString * path = [root stringByAppendingPathComponent:[canvas.source stringByAppendingPathComponent:root]];
	NSString * filepathName = [path stringByAppendingPathComponent:canvas.name];

	filepathName = [filepathName stringByAppendingPathExtension:@"png"];

	UIImage * image = nil;
	NSFileManager * manager = [NSFileManager defaultManager];
	if (manager != nil)
		image = [UIImage imageWithContentsOfFile:filepathName];

	return image;
}

@end
