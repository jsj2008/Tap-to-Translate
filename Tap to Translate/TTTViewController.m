//
//  TTTViewController.m
//  Tap to Translate
//
//  Created by Mohamed Marbouh on 2016-12-13.
//  Copyright © 2016 Mohamed Marbouh. All rights reserved.
//

#import "Interfaces.h"
#import "TTTViewController.h"
#import "TTTLanguageSelectionController.h"
#import "TapToTranslate.h"

#import "UIAlertController+TTT.h"

@interface TTTViewController () <UIPopoverPresentationControllerDelegate, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *overviewView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet TTTLanguageNameView *sourceLanguageView;
@property (weak, nonatomic) IBOutlet TTTLanguageNameView *destinationLanguageView;
@property (weak, nonatomic) IBOutlet UITextView *sourceTextView;
@property (weak, nonatomic) IBOutlet UITextView *resultTextView;
@property (weak, nonatomic) IBOutlet TTTGoogleStyleButton *translationButton;
@property (weak, nonatomic) IBOutlet TTTGoogleStyleButton *translationCopyButton;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerYConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (nonatomic) NSLayoutConstraint *sourceTextViewHeightConstraint;
@property (nonatomic) NSLayoutConstraint *resultTextViewHeightConstraint;

@end

@implementation TTTViewController

- (void)awakeFromNib
{
	[super awakeFromNib];
	
	self.sourceTextView.font = [UIFont fontWithName:@"Roboto-Regular" size:22];
	self.resultTextView.font = [UIFont fontWithName:@"Roboto-Regular" size:22];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[NSNotificationCenter.defaultCenter	addObserver:self
										selector:@selector(applicationWillResign:)
										name:UIApplicationWillResignActiveNotification
										object:nil];
	
	[NSNotificationCenter.defaultCenter addObserver:self
										   selector:@selector(adjustToOSK:)
											   name:UIKeyboardWillShowNotification
											 object:nil];
	
	[NSNotificationCenter.defaultCenter addObserver:self
										   selector:@selector(adjustToOSK:)
											   name:UIKeyboardWillHideNotification
											 object:nil];
	
	self.sourceTextView.text = self.translation[@"sourceText"];
	self.resultTextView.text = self.translation[@"targetText"];
	
	self.sourceTextViewHeightConstraint = [NSLayoutConstraint constraintWithItem:self.sourceTextView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.sourceTextView.contentSize.height];
	self.resultTextViewHeightConstraint = [NSLayoutConstraint constraintWithItem:self.resultTextView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.sourceTextView.contentSize.height];
	
	[self.sourceTextView addConstraint:self.sourceTextViewHeightConstraint];
	[self.resultTextView addConstraint:self.resultTextViewHeightConstraint];
	
	[self.sourceLanguageView configureForTranslation:self.translation isInput:YES];
	[self.destinationLanguageView configureForTranslation:self.translation isInput:NO];
	[self.translationButton configureWithTitle:@"copydrop_new_translation_button"];
	[self.translationCopyButton configureWithTitle:@"copy_btn_text"];
	[self.closeButton setImage:[self.closeButton.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
	[self.moreButton setImage:[self.moreButton.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
}

- (void)textViewDidBeginEditing:(UITextView*)textView
{
	if(!self.translationButton.hidden) {
		textView.text = @"";
	}
	
	self.translationButton.hidden = YES;
}

- (void)textViewDidChange:(UITextView*)textView
{
	if(self.translationCopyButton.hidden) {
		self.translationCopyButton.hidden = NO;
	}
	
	[self changeTranslationKey:@"sourceText" toValue:textView.text];
}

- (void)applicationWillResign:(id)info
{
	[TapToTranslate closeWindow];
}

- (void)adjustToOSK:(NSNotification*)notification
{
	double duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	NSValue *rawRect = notification.userInfo[UIKeyboardFrameEndUserInfoKey];
	CGRect frame = [self.view convertRect:rawRect.CGRectValue fromView:nil];
	CGFloat difference = CGRectGetMinY(frame)-CGRectGetMaxY(self.overviewView.frame)-30;
	
	[self.view layoutIfNeeded];
	[UIView animateWithDuration:duration animations:^{
		self.centerYConstraint.constant = difference < 0 ? difference : 0;
		
		if([notification.name isEqualToString:UIKeyboardWillShowNotification]) {
			self.sourceTextViewHeightConstraint.constant = CGRectGetHeight(self.view.frame)/5;
			self.resultTextViewHeightConstraint.constant = CGRectGetHeight(self.view.frame)/5;
			self.bottomConstraint.constant = -CGRectGetHeight(frame);
		} else if([notification.name isEqualToString:UIKeyboardWillHideNotification]) {
			self.bottomConstraint.constant = 0;
		}
		
		[self.view layoutIfNeeded];
	}];
}

- (void)changeTranslationKey:(NSString*)key toValue:(NSString*)value
{
	[UIApplication.sharedApplication setNetworkActivityIndicatorVisible:YES];
	
	NSMutableDictionary *request = [NSMutableDictionary dictionaryWithDictionary:self.translation];
	request[key] = value;
	
	dispatch_async(dispatch_get_main_queue(), ^{
		[TTTComms requestTranslation:request completion:^(NSDictionary *result) {
			[UIApplication.sharedApplication setNetworkActivityIndicatorVisible:NO];
			
			self.translation = result;
			
			self.sourceTextView.text = self.translation[@"sourceText"];
			self.resultTextView.text = self.translation[@"targetText"];
			
			BOOL detectLanguage = [key isEqualToString:@"sourceLanguage"] && [value isEqualToString:@"auto"];
			
			[self.sourceLanguageView updateTranslation:self.translation wasAutomatic:detectLanguage];
			[self.destinationLanguageView updateTranslation:self.translation wasAutomatic:NO];
			
			if(self.sourceTextView.isFirstResponder) {
				[self.sourceTextView scrollRangeToVisible:NSMakeRange(self.sourceTextView.text.length, 0)];
				[self.resultTextView scrollRangeToVisible:NSMakeRange(self.resultTextView.text.length, 0)];
			}
		}];
	});
}

- (void)changeInputLanguageTo:(NSString*)language
{
	[self changeTranslationKey:@"sourceLanguage" toValue:language];
}

- (void)changeTargetLanguageTo:(NSString*)language
{
	[self changeTranslationKey:@"targetLanguage" toValue:language];
	
	if([[TTTPrefs getPreferenceForKey:@"defaultLanguage"] isEqualToString:@"auto"] && !
	   [[TTTPrefs getPreferenceForKey:@"askedToRememberSetting"] containsObject:@"defaultLanguage"]) {
		[self askToRememberSettingNamed:@"defaultLanguage" completion:^{
			[TTTPrefs setValue:language forKey:@"defaultLanguage"];
		}];
	}
}

- (void)askToRememberSettingNamed:(id)name completion:(void (^)())block
{
	NSMutableArray *temp = [NSMutableArray arrayWithArray:[TTTPrefs getPreferenceForKey:@"askedToRememberSetting"]];
	[temp addObject:name];
	
	[TTTPrefs setValue:temp forKey:@"askedToRememberSetting"];
	
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
																   message:[TTTString("DOWNLOAD_SETTINGS_DIALOG_REMEMBER_SETTINGS_LABEL") stringByAppendingString:@"?"]
															preferredStyle:UIAlertControllerStyleAlert];
	
	[alert addAction:[UIAlertAction actionWithTitle:TTTString("gf_no") style:UIAlertActionStyleCancel handler:nil]];
	[alert addAction:[UIAlertAction actionWithTitle:TTTString("gf_yes") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
		block();
	}]];
	
	[alert show];
}

- (IBAction)tappedLogoButton:(UIButton*)sender
{
	NSString *string = [NSString stringWithFormat:@"googleTranslate://translate?sl=%@&tl=%@&text=%@", self.translation[@"sourceLanguage"], self.translation[@"targetLanguage"], self.translation[@"sourceText"]];
	NSURL *url = [NSURL URLWithString:[string stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet]];
	[UIApplication.sharedApplication openURL:url];
}

- (IBAction)tappedCloseButton:(UIButton*)sender
{
	[TapToTranslate closeWindow];
}

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(UIButton*)sender
{
	__kindof UIViewController *vc = segue.destinationViewController;
	vc.preferredContentSize = CGSizeMake(175, 300);
	vc.modalPresentationStyle = UIModalPresentationPopover;
	vc.popoverPresentationController.delegate = self;
	vc.popoverPresentationController.sourceRect = sender.frame;
	
	if([segue.identifier isEqualToString:@"languageSelection"]) {
		vc.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
		[(TTTLanguageSelectionController*)vc setIsInput:[sender.superview isEqual:self.sourceLanguageView]];
	} else {
		vc.popoverPresentationController.sourceView = self.overviewView;
		vc.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionRight;
		
		UITableViewController *tableVC = segue.destinationViewController;
		tableVC.tableView.delegate = self;
		tableVC.tableView.tableFooterView = UIView.alloc.init;
	}
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController*)controller
{
	return UIModalPresentationNone;
}

- (void)tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
	cell.textLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:16];
	
	switch(indexPath.row) {
		case 0:
			cell.textLabel.text = TTTString("label_copy");
			break;
		case 1:
			cell.textLabel.text = TTTString("label_copydrop_overflow_open_in_main_app");
			break;
	}
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	switch(indexPath.row) {
		case 0:
			[self tappedCopyButton:self.translationCopyButton];
			break;
		case 1:
			[self tappedLogoButton:nil];
			break;
		case 2:
			[UIApplication.sharedApplication openURL:[NSURL URLWithString:@"https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=RCVQUTKUZ3964"]];
			break;
	}
	
	[(UIViewController*)tableView.nextResponder dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch*>*)touches withEvent:(UIEvent*)event
{
	if(!CGRectContainsPoint(self.overviewView.frame, [touches.anyObject locationInView:self.view])) {
		if(self.sourceTextView.isFirstResponder) {
			[self.sourceTextView resignFirstResponder];
		} else {
			[TapToTranslate closeWindow];
		}
	}
}

- (IBAction)tappedNewTranslationButton:(UIButton*)sender
{
	self.sourceTextView.editable = YES;
	
	[self.sourceTextView becomeFirstResponder];
}

- (IBAction)tappedCopyButton:(UIButton*)sender
{
	[TapToTranslate changeHookingStatus:NO];
	
	[UIPasteboard generalPasteboard].string = self.translation[@"targetText"];
	
	[TapToTranslate changeHookingStatus:YES];
	
	[TapToTranslate closeWindow];
}

@end
