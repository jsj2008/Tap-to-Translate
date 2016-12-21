//
//  TTTLanguageSelectionController.m
//  Tap to Translate
//
//  Created by Mohamed Marbouh on 2016-12-14.
//  Copyright © 2016 Mohamed Marbouh. All rights reserved.
//

#import "TTTLanguageSelectionController.h"
#import "Interfaces.h"
#import "TTTViewController.h"

@interface TTTLanguageSelectionController ()

@property(nonatomic) NSArray<NSArray*> *languages;

@end

@implementation TTTLanguageSelectionController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.tableView.emptyDataSetSource = self;
	self.tableView.tableFooterView = UIView.alloc.init;
	self.languages = @[@[@"fr", @"French"]];
	
	[TTTComms requestAvailableLanguages:^(NSArray *languages) {
		NSArray *array = self.isInput ? @[@[@"auto", TTTString("twslang_auto")]] : @[];
		
		self.languages = [array arrayByAddingObjectsFromArray:languages];

		[self.tableView reloadData];
	}];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.languages.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"languageCell" forIndexPath:indexPath];
	cell.textLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:16];
	cell.textLabel.text = self.languages[indexPath.row].lastObject;
	
    return cell;
}

- (UIView*)customViewForEmptyDataSet:(UIScrollView*)scrollView
{
	UIActivityIndicatorView *activityView = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	[activityView startAnimating];
	return activityView;
}

- (UIColor*)backgroundColorForEmptyDataSet:(UIScrollView*)scrollView
{
	return [UIColor colorWithRed:.92 green:.92 blue:.92 alpha:1];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	TTTViewController *viewController = (TTTViewController*)self._sourceViewControllerIfPresentedViaPopoverSegue;
	
	if(self.isInput) {
		[viewController performSelector:@selector(changeInputLanguageTo:) withObject:self.languages[indexPath.row].firstObject afterDelay:0];
	} else {
		[viewController performSelector:@selector(changeTargetLanguageTo:) withObject:self.languages[indexPath.row].firstObject afterDelay:0];
	}
	
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
