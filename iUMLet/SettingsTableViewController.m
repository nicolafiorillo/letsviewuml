//
//  SettingsTableViewController.m
//  Let's view UML
//
//  Created by Nicola Fiorillo on 9/7/13.
//  Copyright (c) 2013 Nicola Fiorillo. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "Settings.h"
#import "InfoViewController.h"
#import "ConstStrings.h"

@interface SettingsTableViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *showGridSwitch;

@end

@implementation SettingsTableViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.showGridSwitch.on = [Settings getInstance].showGrid;
}

- (void)viewWillAppear:(BOOL)animated
{
	[self.navigationItem setHidesBackButton:YES animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[self.navigationItem setHidesBackButton:NO animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? 1 : 3;
}

- (IBAction)showGridValueChanged:(UISwitch *)sender
{
	[Settings getInstance].showGrid = self.showGridSwitch.on;
}

- (IBAction)doneButtonPressed:(UIBarButtonItem *)sender
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"ToLicense"]) {
		InfoViewController * destinationController = segue.destinationViewController;
		destinationController.text = kAppLicense;
	}
	else if ([segue.identifier isEqualToString:@"ToCredits"]) {
		InfoViewController * destinationController = segue.destinationViewController;
		destinationController.text = kAppCredits;
	}
	else if ([segue.identifier isEqualToString:@"ToAbout"]) {
		InfoViewController * destinationController = segue.destinationViewController;

		NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
		NSString * appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];

		destinationController.text = [NSString stringWithFormat:kAppAbout, appName, version];
	}
}


@end
