//
//  CanvasViewController.m
//  Let's view UML
//
//  Created by Nicola Fiorillo on 6/5/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CanvasViewController.h"
#import "CanvasView.h"
#import "Preview.h"
#import "Const.h"

@interface CanvasViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic)CanvasView * canvasView;
@property (nonatomic)BOOL navigationBarHidden;
@property (weak, nonatomic) IBOutlet UILabel *zoomLabel;
@property (weak, nonatomic) IBOutlet UILabel *notLoadableLabel;
@property (strong, nonatomic)Preview * previewCache;

@end

@implementation CanvasViewController

-(void)setCanvas:(Canvas *)canvas
{
	_canvas = canvas;
	_canvasView = [[CanvasView alloc] initWithCanvas:canvas];
}

- (Preview *)previewCache
{
	if (!_previewCache)
		_previewCache = [Preview new];
	
	return _previewCache;
}

- (void)setShowGrid:(BOOL)showGrid
{
	if (self.canvasView && self.canvas)
		self.canvasView.showGrid = showGrid;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.scrollView.zoomScale = kScrollViewZoomScale;
	self.scrollView.minimumZoomScale = kScrollViewMinimumZoomScale;
	self.scrollView.maximumZoomScale = kScrollViewMaximumZoomScale;
	self.scrollView.alwaysBounceHorizontal = YES;
	self.scrollView.alwaysBounceVertical = YES;

	self.scrollView.delegate = self;

	if (self.canvasView)
	{
		self.scrollView.contentSize = self.canvasView.bounds.size;
		[self.scrollView addSubview:self.canvasView];

		[self showNotLoadable];
	}

	UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];

	tapRecognizer.numberOfTapsRequired = 1;
	tapRecognizer.cancelsTouchesInView = NO;
	[self.scrollView addGestureRecognizer:tapRecognizer];

	[self.scrollView flashScrollIndicators];
	
	[self showAndHideNavBar];
	[self setAndHideZoom];
}

- (void)showNotLoadable
{
	self.notLoadableLabel.alpha = 0.0f;
	
	if (!self.canvas.isLoaded)
	{
		dispatch_queue_t downloadQueue = dispatch_queue_create("show not loadable", NULL);
		dispatch_async(downloadQueue, ^{
			sleep(.5f);
			dispatch_async(dispatch_get_main_queue(), ^{
				[UIView animateWithDuration: 1.8f animations:^{ self.notLoadableLabel.alpha = 1.0f; }];
			});
		});
	}
}

- (void)setAndHideZoom
{
	self.zoomLabel.text = [NSString stringWithFormat:@"zoom: %d%%", self.canvas.zoomLevel * 10];

	dispatch_queue_t downloadQueue = dispatch_queue_create("set and hide zoom", NULL);
	dispatch_async(downloadQueue, ^{
		sleep(2.5f);
		dispatch_async(dispatch_get_main_queue(), ^{
			[UIView animateWithDuration: .5f animations:^{ self.zoomLabel.alpha = 0.0; }];
		});
	});
}

- (void)showAndHideNavBar
{
	[self.navigationController setNavigationBarHidden:NO];
	self.navigationBarHidden = NO;

	dispatch_queue_t downloadQueue = dispatch_queue_create("show and hide nav bar", NULL);
	dispatch_async(downloadQueue, ^{
		sleep(2.0f);
		dispatch_async(dispatch_get_main_queue(), ^{
			if (!self.navigationBarHidden)
				[self toggleNavigationBar];
		});
	});
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return self.canvasView;
}

- (void)tapGesture:(UITapGestureRecognizer *)gesture
{
	[self toggleNavigationBar];
}

- (void)toggleNavigationBar
{
	[self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[self generatePreview];
	[self.delegate didDismiss:self];
}

- (void)generatePreview
{
	CGFloat width = 210 * 3;
	CGFloat height = 160 * 3;

	CGPoint origin = self.scrollView.contentOffset;
	CGRect frame = CGRectMake(origin.x, origin.y, width, height);	// full view: self.view.frame;

	UIImage * image = [self imageByCropping:self.scrollView toRect:frame];
	[self.previewCache saveCanvas:self.canvas asImage:image];
}

- (UIImage *)imageByCropping:(UIScrollView *)scrollView toRect:(CGRect)rect
{
    CGSize pageSize = rect.size;
    UIGraphicsBeginImageContext(pageSize);

    CGContextRef resizedContext = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(resizedContext, -rect.origin.x, -rect.origin.y);

//	scrollView.zoomScale = 1.0f;
	
    [scrollView.layer renderInContext:resizedContext];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return image;
}

@end
