//
//  TapToTranslate.m
//  
//
//  Created by Mohamed Marbouh on 2016-06-15.
//
//

#import "Interfaces.h"
#import "UIView+TTT.h"
#import "TTTViewController.h"

static TTTViewController *viewController;
static BOOL hook = YES;

@implementation TapToTranslate

+ (void)prepareWindowWithTranslation:(NSDictionary*)translation
{	
	[TTTAssets.sharedInstance prepareFontIfNecessary];
	
	for(UIView *subview in [UIView TTT_allSubviews]) {
		if(subview.canResignFirstResponder) {
			[subview resignFirstResponder];
		}
	}
	
	NSBundle *bundle = [NSBundle bundleWithPath:@"/Library/Application Support/Tap to Translate/Assets.bundle"];
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:bundle];
	
	viewController = storyboard.instantiateInitialViewController;
	viewController.translation = translation;
}

+ (void)showWindowIfPrepared
{
	if(viewController) {
		UIViewController *vc = UIApplication.sharedApplication.keyWindow.rootViewController;
		vc.view.alpha = 0;
		
		[vc addChildViewController:viewController];
		[vc.view addSubview:viewController.view];
		[viewController didMoveToParentViewController:vc];
		
		[UIView animateWithDuration:.3 animations:^{
			vc.view.alpha = 1;
		}];
	}
}

+ (void)closeWindow
{
	[UIView animateWithDuration:.5 animations:^{
		viewController.view.alpha = 0;
	} completion:^(BOOL finished) {
		[viewController.view removeFromSuperview];
		[viewController removeFromParentViewController];
	}];
}

+ (void)updateLanguage:(NSString*)language isInput:(BOOL)input
{
	if(input) {
		[viewController performSelector:@selector(changeInputLanguageTo:) withObject:language afterDelay:0];
	} else {
		[viewController performSelector:@selector(changeTargetLanguageTo:) withObject:language afterDelay:0];
	}
}

+ (BOOL)hooksEnabled
{
	return hook;
}

+ (void)changeHookingStatus:(BOOL)shouldHook
{
	hook = shouldHook;
}

@end
