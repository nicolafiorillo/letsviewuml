//
//  ElementViewFactory.m
//  Let's view UML
//
//  Created by Nicola Fiorillo on 7/5/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import "ElementViewFactory.h"
#import "ClassElementView.h"
#import "RelationElementView.h"
#import "UseCaseElementView.h"
#import "TextElementView.h"
#import "NoteElementView.h"
#import "ActorElementView.h"
#import "PackageElementView.h"
#import "InterfaceElementView.h"
#import "ThreeWayRelationElementView.h"
#import "StateElementView.h"
#import "InitialStateElementView.h"
#import "FinalStateElementView.h"

static NSDictionary * elementMap;

@interface ElementViewFactory()

@end

@implementation ElementViewFactory

+ (NSDictionary *)map
{
	if (!elementMap)
	{
		elementMap =
		@{
			@"com.umlet.element.Class":							[ClassElementView class],
			@"com.umlet.element.Relation":						[RelationElementView class],
			@"com.umlet.element.UseCase":							[UseCaseElementView class],
			@"com.umlet.element.custom.Text":					[TextElementView class],
			@"com.umlet.element.Note":							[NoteElementView class],
			@"com.umlet.element.Actor":							[ActorElementView class],
			@"com.umlet.element.Package":							[PackageElementView class],
			@"com.umlet.element.Interface":						[InterfaceElementView class],
			@"com.umlet.element.custom.ThreeWayRelation":		[ThreeWayRelationElementView class],
			@"com.umlet.element.custom.State":					[StateElementView class],
			@"com.umlet.element.custom.InitialState":			[InitialStateElementView class],
			@"com.umlet.element.custom.FinalState":			[FinalStateElementView class]
		};
	}
	
	return elementMap;
}

+ (ElementView *)createWithElement:(Element *)element andZoomLevel:(NSInteger)zoomLevel
{
	ElementView * view = nil;

	if ([self.map objectForKey:element.type] != nil)
		view = [[[self.map objectForKey:element.type] alloc] initWithElement:(Element *)element andZoom:zoomLevel];

	return view;
}

@end
