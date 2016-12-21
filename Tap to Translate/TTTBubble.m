//
//  TTTBubble.m
//  
//
//  Created by Mohamed Marbouh on 2016-05-12.
//
//

#import "Interfaces.h"
#import "UIAlertController+TTT.h"
#import "TapToTranslate.h"

@interface TTTBubble ()

@property BOOL isFirstTime;
@property BOOL isOSKshown;
@property BOOL noNetworkError;
@property CGFloat OSKy;

@property(nonatomic, retain) UIImage *icon;
@property(nonatomic, retain) NSString *text;
@property(nonatomic, retain) NSDictionary *translation;

@end

static BOOL movedBubble = NO;

@implementation TTTBubble

+ (instancetype)sharedInstance
{
	static TTTBubble *sharedInstance = nil;
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		sharedInstance = [self buttonWithType:UIButtonTypeCustom];
	
		sharedInstance.icon = [[TTTAssets sharedInstance] imageNamed:@"popover_icon.png"];
		
		sharedInstance.clipsToBounds = YES;
		sharedInstance.frame = CGRectMake(0, 0, 60, 60);
		
		[sharedInstance addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:sharedInstance action:@selector(dismiss)]];
		[sharedInstance setImage:sharedInstance.icon forState:UIControlStateNormal];
	});
	
	return sharedInstance;
}

- (void)positionAccordingToView:(UIView*)view
{
	CGRect newPosition = self.frame;
	newPosition.origin.x = CGRectGetWidth(view.frame)-CGRectGetWidth(self.frame)-10.f;
	newPosition.origin.y = CGRectGetHeight(view.frame)/3.f;
	
	[UIView animateWithDuration:.4 animations:^{
		self.frame = newPosition;
	}];
}

- (void)positionAccordingToWindow
{
	[self positionAccordingToView:self.window];
}

- (void)positionAccordingToSuperview
{
	[self positionAccordingToView:self.superview];
}

- (void)repositionAccordingToOSK
{
	if(CGRectGetMaxY(self.frame) >= self.OSKy) {
		CGRect newPosition = self.frame;
		newPosition.origin.y = self.OSKy-CGRectGetHeight(self.frame)-55.f;
		
		[UIView animateWithDuration:.3 animations:^{
			self.frame = newPosition;
		}];
	}
}

- (void)dismiss
{
	 [self deconfigureForEvents];
	 [self removeFromSuperview];
}

- (void)dismissAnimated:(void (^)())block
{
	[UIView animateWithDuration:0.5f
						  delay:0.0f
						options:UIViewAnimationOptionCurveEaseOut
					 animations:^{
						 CGRect frame = self.frame;
						 frame.origin.x += CGRectGetWidth([UIApplication sharedApplication].keyWindow.frame);
						 self.frame = frame;
					 }
					 completion:^(BOOL finished){
						 if (finished) {
							 block();
							 
							 [self dismiss];
						 }
					 }];
}

- (void)configureForEvents
{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(applicationWillResign:)
												 name:UIApplicationWillResignActiveNotification
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWasShown:)
												 name:UIKeyboardDidShowNotification
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWasHidden:)
												 name:UIKeyboardDidHideNotification
											   object:nil];
	
	[self addTarget:self action:@selector(dragOut:withEvent:) forControlEvents:UIControlEventTouchDragOutside|UIControlEventTouchDragInside];
	[self addTarget:self action:@selector(finishedDrag:withEvent:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
}

- (void)configureForTranslation:(NSDictionary*)translation
{
	[self setTranslation:translation];
}

- (void)configureForFirstTime:(NSString*)text
{
	self.isFirstTime = YES;
	self.text = text;
}

- (void)configureForNoNetworkError
{
	self.translation = nil;
	self.noNetworkError = YES;
}

- (void)loadTranslationAndShowWindow
{
	[self dismissAnimated:^{
		[self _showLoading];
	}];
}

- (void)showErrorAlert
{
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:TTTString("ERROR_MESSAGEBOX_TITLE_GENERAL_FAILURE")
																   message:[NSString stringWithFormat:TTTString("ERROR_MESSAGEBOX_BODY_GENERAL_FAILURE"), -1]
															preferredStyle:UIAlertControllerStyleAlert];
	
	[alert addAction:[UIAlertAction actionWithTitle:TTTString("OK_BUTTON_LABEL") style:UIAlertActionStyleCancel handler:nil]];
	[alert show];
}

- (void)_showLoading
{
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:TTTString("PLEASE_WAIT_MESSAGE")
																   message:@"\n\n"
															preferredStyle:UIAlertControllerStyleAlert];
	
	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	spinner.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	spinner.color = [UIColor blackColor];
	spinner.frame = alert.view.bounds;
	
	[spinner startAnimating];
	
	[alert addAction:[UIAlertAction actionWithTitle:TTTString("BUTTON_CANCEL") style:UIAlertActionStyleCancel handler:nil]];
	[alert.view addSubview:spinner];
	[alert show];
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	
	dispatch_async(dispatch_get_main_queue(), ^{
		[TTTComms requestTranslationForText:self.text completion:^(NSDictionary *result) {
			[alert dismissViewControllerAnimated:YES completion:^{
				[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
				
				[TapToTranslate prepareWindowWithTranslation:result];
				[TapToTranslate showWindowIfPrepared];
			}];
		}];
	});
}

- (void)showTranslationWindow
{
	[self dismissAnimated:^{
		[TapToTranslate prepareWindowWithTranslation:self.translation];
		[TapToTranslate showWindowIfPrepared];
	}];
}

- (void)showNoNetworkError
{
	[UIView animateWithDuration:0.5f
						  delay:0.0f
						options:UIViewAnimationOptionCurveEaseOut
					 animations:^{
						 CGRect frame = self.frame;
						 frame.origin.x += CGRectGetWidth([UIApplication sharedApplication].keyWindow.frame);
						 self.frame = frame;
					 }
					 completion:^(BOOL finished){
						 if(finished) {
							 UIAlertController *alert = [UIAlertController alertControllerWithTitle:TTTString("ERROR_MESSAGEBOX_TITLE_NETWORK_ERROR")
																							message:TTTString("MESSAGEBOX_TTS_NETWORK_FAILED")
																					 preferredStyle:UIAlertControllerStyleAlert];
							 
							 [alert addAction:[UIAlertAction actionWithTitle:TTTString("OK_BUTTON_LABEL") style:UIAlertActionStyleCancel handler:nil]];
							 [alert show];
						 }
					 }];
}

- (void)deconfigureForEvents
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)applicationWillResign:(id)info
{
	[self dismiss];
}

- (void)keyboardWasShown:(NSNotification*)notification
{
	CGFloat y = CGRectGetMinY([[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue]);
	
	self.isOSKshown = YES;
	self.OSKy = y;

	[self repositionAccordingToOSK];
}

- (void)keyboardWasHidden:(id)sender
{
	self.isOSKshown = NO;
}

- (IBAction)dragOut:(id)sender withEvent:(UIEvent*)event
{
	self.center = [event.allTouches.anyObject locationInView:self.window];
	movedBubble = YES;
}

- (IBAction)finishedDrag:(id)sender withEvent:(UIEvent*)event
{
	if(movedBubble) {
		if(self.isOSKshown) {
			[self repositionAccordingToOSK];
		}
		
		CGRect newPosition = self.frame;
		CGPoint eventCentre = [event.allTouches.anyObject locationInView:self.window];
		
		if(eventCentre.x <= CGRectGetWidth(self.window.frame)/2) {
			newPosition.origin.x = 10.f;
		} else {
			newPosition.origin.x = CGRectGetWidth(self.window.frame)-CGRectGetWidth(self.frame)-10.f;
		}
		
		[UIView animateWithDuration:.6 animations:^{
			self.frame = newPosition;
		}];
		
		movedBubble = NO;
	} else {
		if(self.translation) {
			[self showTranslationWindow];
		} else if(self.noNetworkError) {
			[self showNoNetworkError];
		} else if(self.isFirstTime) {
			[self loadTranslationAndShowWindow];
		} else {
			[self showErrorAlert];
		}
	}
}

@end
