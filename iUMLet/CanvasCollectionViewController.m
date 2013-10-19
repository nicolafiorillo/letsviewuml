//
//  CanvasCollectionViewController.m
//  Let's view UML
//
//  Created by Nicola Fiorillo on 7/16/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import "CanvasCollectionViewController.h"
#import "CanvasItemCollectionViewCell.h"
#import "GroupItemCollectionViewCell.h"
#import "CanvasViewController.h"
#import "LocalRepository.h"
#import "Canvas.h"
#import "Grid.h"
#import "Preview.h"
#import "UIViewController+BackgrounderViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface CanvasCollectionViewController () <CanvasViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *canvasCollectionView;

@end

@implementation CanvasCollectionViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
	
	[self.canvasCollectionView addGestureRecognizer:tapRecognizer];

	self.collectionView.backgroundView = [[UIImageView alloc] initWithImage:nil];
	[self setBackgroudByOrientation];

	self.navigationController.navigationBar.translucent = YES;
}

- (void)viewDidLayoutSubviews
{
	[self setBackgroudByOrientation];
}

- (void)setBackgroudByOrientation
{
	((UIImageView *)self.collectionView.backgroundView).image = [UIImage imageNamed:self.backgroudByOrientation];
}

- (Repository *)canvasRepository
{
	if (!_canvasRepository)
		_canvasRepository = [LocalRepository createLocalRepository];

	return _canvasRepository;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return self.canvasRepository.numberOfItems;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	NSObject * i  = [self.canvasRepository itemAtIndex:indexPath.item];

	UICollectionViewCell * cell = nil;
	
	if ([i isKindOfClass:[Canvas class]])
	{
		cell = [self.canvasCollectionView dequeueReusableCellWithReuseIdentifier:@"CanvasItem" forIndexPath:indexPath];

		if ([cell isKindOfClass:[CanvasItemCollectionViewCell class]])
		{
			CanvasItemCollectionViewCell * item = (CanvasItemCollectionViewCell *)cell;

			Canvas * canvas = (Canvas *)i;
			item.name = canvas.name;
			item.preview = [Preview loadPreview:canvas];

			[item setNeedsDisplay];
		}
	}
	else if ([i isKindOfClass:[Repository class]])
	{
		cell = [self.canvasCollectionView dequeueReusableCellWithReuseIdentifier:@"GroupItem" forIndexPath:indexPath];

		GroupItemCollectionViewCell * item = (GroupItemCollectionViewCell *)cell;

		Repository * repo = (Repository *)i;
		item.name = repo.name;
		item.preview = nil;
	}
	
	return cell;
}

- (void)tapGesture:(UITapGestureRecognizer *)gesture
{
	CGPoint tapLocation = [gesture locationInView:self.canvasCollectionView];
	NSIndexPath * indexPath = [self.canvasCollectionView indexPathForItemAtPoint:tapLocation];

	if (indexPath)
	{
		UICollectionViewCell * cell = [self.canvasCollectionView cellForItemAtIndexPath:indexPath];
		if ([cell isKindOfClass:[CanvasItemCollectionViewCell class]])
		{
			Canvas * canvas = [self.canvasRepository loadCanvasAtIndex:indexPath.item];

			if (canvas)
			{
				CanvasViewController * canvasViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CanvasDiagram"];
				canvasViewController.canvas = canvas;

				canvasViewController.title = canvas.name;
				canvasViewController.indexPath = indexPath;
				canvasViewController.delegate = self;

				[self.navigationController pushViewController:canvasViewController animated:YES];
			}
		}
		else if ([cell isKindOfClass:[GroupItemCollectionViewCell class]])
		{
			Repository * repo  = [self.canvasRepository itemAtIndex:indexPath.item];

			if (repo)
			{
				CanvasCollectionViewController * canvasCollectionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CanvasCollection"];

				canvasCollectionViewController.canvasRepository	= repo;
				canvasCollectionViewController.title = repo.name;

				[self.navigationController pushViewController:canvasCollectionViewController animated:YES];
			}
		}
	}
}

- (void)didDismiss:(CanvasViewController *)canvasViewController
{
	NSLog(@"Calling cell update: %@", canvasViewController.indexPath);
	[self.collectionView reloadItemsAtIndexPaths:@[canvasViewController.indexPath]];
}

@end
