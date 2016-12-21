//
//  UIAlertController+TTT.m
//  
//
//  Created by Mohamed Marbouh on 2016-07-28.
//
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

#import "UIAlertController+TTT.h"

@implementation UIAlertController (TTT)

@dynamic alertWindow;

- (void)setAlertWindow:(UIWindow*)alertWindow
{
	objc_setAssociatedObject(self, @selector(alertWindow), alertWindow, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIWindow*)alertWindow
{
	return objc_getAssociatedObject(self, @selector(alertWindow));
}

- (void)show
{
	[self show:YES];
}

- (void)show:(BOOL)animated
{
	self.alertWindow = [UIWindow.alloc initWithFrame:UIScreen.mainScreen.bounds];
	self.alertWindow.rootViewController = UIViewController.alloc.init;
	
	if([UIApplication.sharedApplication.delegate respondsToSelector:@selector(window)]) {
		self.alertWindow.tintColor = UIApplication.sharedApplication.delegate.window.tintColor;
	}
	
	// window level is above the top window (this makes the alert, if it's a sheet, show over the keyboard)
	UIWindow *topWindow = UIApplication.sharedApplication.windows.lastObject;
	self.alertWindow.windowLevel = topWindow.windowLevel + 1;
	
	[self.alertWindow makeKeyAndVisible];
	[self.alertWindow.rootViewController presentViewController:self animated:animated completion:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	
	// precaution to insure window gets destroyed
	self.alertWindow.hidden = YES;
	self.alertWindow = nil;
}

@end
