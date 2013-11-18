//
//  Preview.m
//  Let's view UML
//
//  Created by Nicola Fiorillo on 18/11/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import "Preview.h"

@interface Preview()

@property (strong, nonatomic) NSString * cacheRoot;

@end

@implementation Preview

- (NSString *)cacheRoot
{
	if (_cacheRoot == nil) {
		NSSearchPathDirectory source = NSCachesDirectory;
		
#if TARGET_IPHONE_SIMULATOR
		source = NSDocumentDirectory;
#endif
		
		NSArray * paths = NSSearchPathForDirectoriesInDomains(source, NSUserDomainMask, YES);
		_cacheRoot = [paths objectAtIndex:0];
	}
	
	return _cacheRoot;
}

- (void)saveCanvas:(Canvas *)canvas asImage:(UIImage *)image
{
	NSString * path = [self.cacheRoot stringByAppendingPathComponent:[canvas.source stringByAppendingPathComponent:self.cacheRoot]];
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

- (UIImage *)loadForCanvas:(Canvas *)canvas
{
	NSString * path = [self.cacheRoot stringByAppendingPathComponent:[canvas.source stringByAppendingPathComponent:self.cacheRoot]];
	NSString * filepathName = [path stringByAppendingPathComponent:canvas.name];
	
	filepathName = [filepathName stringByAppendingPathExtension:@"png"];
	
	UIImage * image = nil;
	NSFileManager * manager = [NSFileManager defaultManager];
	if (manager != nil)
		image = [UIImage imageWithContentsOfFile:filepathName];
	
	return image;
}

@end
