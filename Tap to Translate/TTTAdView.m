//
//  TTTAdView.m
//  Tap to Translate
//
//  Created by Mohamed Marbouh on 2016-12-15.
//  Copyright © 2016 Mohamed Marbouh. All rights reserved.
//

#import "TTTAdView.h"

@interface TTTAdView ()

@property(nonatomic, weak) IBOutlet UIImageView *logoImageView;
@property(nonatomic, weak) IBOutlet UILabel *alternatingLabel;
@property(nonatomic, weak) IBOutlet UIImageView *screenshotView;
@property(nonatomic, weak) IBOutlet NSLayoutConstraint *screenshotWidthConstraint;
@property(nonatomic) NSArray *bannerTitles;
@property(nonatomic) CAGradientLayer *gradientLayer;

@end

@implementation TTTAdView

- (void)awakeFromNib
{
	[super awakeFromNib];
	
	self.bannerTitles = @[@"biteSMS for iOS 9",
						  @"Quick reply and compose",
						  @"Message scheduling with attachments",
						  @"Message templates and more"];
	
	self.logoImageView.layer.cornerRadius = 2.5;
	self.logoImageView.layer.masksToBounds = YES;
	self.screenshotWidthConstraint.constant = self.screenshotView.image.size.width;
	
	self.gradientLayer = CAGradientLayer.layer;
	self.gradientLayer.colors = @[(id)UIColor.whiteColor.CGColor, (id)self.averageColor.CGColor];
	
	[self.layer insertSublayer:self.gradientLayer atIndex:0];
	
	NSTimer *timer = [NSTimer timerWithTimeInterval:2.5 target:self selector:@selector(changeCurrentText) userInfo:nil repeats:YES];
	[NSRunLoop.currentRunLoop addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	self.gradientLayer.frame = self.bounds;
}

- (UIColor*)averageColor
{
	unsigned char rgba[4];
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate(rgba, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
 
	CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), self.logoImageView.image.CGImage);
	CGColorSpaceRelease(colorSpace);
	CGContextRelease(context);
 
	if(rgba[3] > 0) {
		CGFloat alpha = rgba[3]/255.0;
		CGFloat multiplier = alpha/255.0;
		return [UIColor colorWithRed:((CGFloat)rgba[0])*multiplier
							   green:((CGFloat)rgba[1])*multiplier
								blue:((CGFloat)rgba[2])*multiplier
							   alpha:alpha];
	} else {
		return [UIColor colorWithRed:((CGFloat)rgba[0])/255.0
							   green:((CGFloat)rgba[1])/255.0
								blue:((CGFloat)rgba[2])/255.0
							   alpha:((CGFloat)rgba[3])/255.0];
	}
}

- (void)changeCurrentText
{
	self.tag++;
	
	if(self.tag >= self.bannerTitles.count) {
		self.tag = 0;
	}
	
	self.alternatingLabel.text = self.bannerTitles[self.tag];
}

- (IBAction)tappedView:(UITapGestureRecognizer*)sender
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"cydia://package/com.mootjeuh.columba9"]];
}

@end
