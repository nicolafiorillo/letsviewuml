//
//  CanvasLoader.m
//  Let's view UML
//
//  Created by Nicola Fiorillo on 6/5/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import "CanvasLoader.h"
#import "Element.h"
#import "SMXMLDocument.h"

static NSString * program = @"umlet";
static const CGFloat minVersion = 11.0f;

@implementation CanvasLoader

+ (void)loadFromFile:(Canvas *)canvas
{
	NSString * file = canvas.fullPath;
	NSData *data = [NSData dataWithContentsOfFile:file];

	NSError *error;
	SMXMLDocument *document = [SMXMLDocument documentWithData:data error:&error];

    if (!error)
	{
		SMXMLElement *diagram = document.root;
		if (![diagram.name isEqualToString:@"diagram"])
		{
			NSLog(@"Document %@ has not uxf format", file);
			return;
		}

		canvas.program = [diagram attributeNamed:@"program"];
		canvas.programVersion = [diagram attributeNamed:@"version"];
		CGFloat version = [canvas.programVersion floatValue];

		if ([canvas.program.lowercaseString isEqualToString:program] && version >= minVersion)
		{
			SMXMLElement *zoom = [[diagram childrenNamed:@"zoom_level"] objectAtIndex:0];

			if (zoom)
				canvas.zoomLevel = [zoom.value integerValue];
			else
				NSLog(@"Document %@ has not zoom information", file);

			[self loadElementsFromParent:diagram inCanvas:canvas];

			canvas.loaded = YES;
		}
	}
	else
	{
        NSLog(@"Error while parsing the document %@: %@", file, error);
		return;
	}
}

+ (void)loadElementsFromParent:(SMXMLElement *)diagram inCanvas:(Canvas *)canvas
{
	NSAssert(diagram, @"diagram should exists");
	NSAssert(canvas, @"canvas should exists");

	for (SMXMLElement *element in [diagram childrenNamed:@"element"])
	{
		Element * e = [[Element alloc] init];

		SMXMLElement *type = [[element childrenNamed:@"type"] objectAtIndex:0];
		e.type = type.value;
		
		SMXMLElement *panelAttributes = [[element childrenNamed:@"panel_attributes"] objectAtIndex:0];
		e.panel_attributes = panelAttributes.value != nil ? panelAttributes.value : @"";

		SMXMLElement *additionalAttributes = [[element childrenNamed:@"additional_attributes"] objectAtIndex:0];
		e.additional_attributes = additionalAttributes.value != nil ? additionalAttributes.value : @"";

		SMXMLElement *coordinates = [[element childrenNamed:@"coordinates"] objectAtIndex:0];
		SMXMLElement *x = [[coordinates childrenNamed:@"x"] objectAtIndex:0];
		SMXMLElement *y = [[coordinates childrenNamed:@"y"] objectAtIndex:0];
		SMXMLElement *w = [[coordinates childrenNamed:@"w"] objectAtIndex:0];
		SMXMLElement *h = [[coordinates childrenNamed:@"h"] objectAtIndex:0];

		e.coordinates = CGRectMake([x.value floatValue], [y.value floatValue], [w.value floatValue], [h.value floatValue]);
		
		[canvas.elements addObject:e];
	}

	for (SMXMLElement *group in [diagram childrenNamed:@"group"])
		[self loadElementsFromParent:group inCanvas:canvas];
}

@end
