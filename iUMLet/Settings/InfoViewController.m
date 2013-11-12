//
//  InfoViewController.m
//  Let's view UML
//
//  Created by Nicola Fiorillo on 9/9/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *infoWebView;

@end

@implementation InfoViewController

- (void)viewDidLoad
{
	self.infoWebView.delegate = self;
	[self.infoWebView loadHTMLString:self.text baseURL:nil];
	
	self.infoWebView.scrollView.scrollEnabled = NO;
}

- (BOOL)webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType) inType
{
	if (inType == UIWebViewNavigationTypeLinkClicked)
	{
		[[UIApplication sharedApplication] openURL:[inRequest URL]];
		return NO;
	}

	return YES;
}

@end
