//
//  TapToTranslate.m
//  
//
//  Created by Mohamed Marbouh on 2016-06-15.
//
//

#import "headers/headers.h"
#import "UIView+TTT.h"

static UIVisualEffectView *visualEffectView = nil;
static TTTResultsView *resultsView = nil;
static BOOL hook = YES;

@implementation TapToTranslate

+ (void)prepareWindowWithTranslation:(NSDictionary*)translation
{	
	[[TTTAssets sharedInstance] prepareFontIfNecessary];
	
	for(UIView *subview in [UIView TTT_allSubviews]) {
		if(subview.canResignFirstResponder) {
			[subview resignFirstResponder];
		}
	}
	
	UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
	
	visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
	visualEffectView.alpha = 0;
	visualEffectView.frame = [UIApplication sharedApplication].keyWindow.bounds;
	
	resultsView = [[TTTResultsView alloc] initWithTranslation:translation];
	resultsView.blurView = visualEffectView;
}

+ (void)showWindowIfPrepared
{
	if(visualEffectView && resultsView) {
		[[UIApplication sharedApplication].keyWindow addSubview:visualEffectView];
		[resultsView expandIntoView:[UIApplication sharedApplication].keyWindow finished:^{
			[UIView animateWithDuration:.3 animations:^{
				visualEffectView.alpha = 1;
			}];
		}];
	}
}

+ (void)updateLanguage:(NSString*)language isInput:(BOOL)input
{
	if(input) {
		[resultsView performSelector:@selector(changeInputLanguageTo:) withObject:language afterDelay:0];
	} else {
		[resultsView performSelector:@selector(changeTargetLanguageTo:) withObject:language afterDelay:0];
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

+ (void)copyTextAndExit
{
	[resultsView performSelector:@selector(tappedCopyButton) withObject:nil afterDelay:0];
}

+ (void)openInGoogleTranslateApp
{
	[resultsView performSelector:@selector(openTranslationInApp) withObject:nil afterDelay:0];
}

@end
