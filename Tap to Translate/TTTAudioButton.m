//
//  TTTAudioButton.m
//  Tap to Translate
//
//  Created by Mohamed Marbouh on 2016-12-13.
//  Copyright © 2016 Mohamed Marbouh. All rights reserved.
//

#import "TTTAudioButton.h"
#import "TTTAssets.h"
#import "Interfaces.h"

@interface TTTAudioButton ()

@property(nonatomic) UIActivityIndicatorView *spinner;

@end

@implementation TTTAudioButton

- (void)awakeFromNib
{
	[super awakeFromNib];
	
	self.tintColor = [TTTComms isInternetAvailable] ? [UIColor colorWithRed:0 green:.478431 blue:1 alpha:1] : [UIColor grayColor];
	
	UIImage *speakerImage = [[TTTAssets sharedInstance] imageNamed:@"qtm_ic_volume_up"];
	speakerImage = [speakerImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	
	[self setImage:speakerImage forState:UIControlStateNormal];
}

- (IBAction)tappedButton:(TTTAudioButton*)sender
{
	if(!sender.spinner) {
		sender.spinner = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		
		[sender addSubview:sender.spinner];
	}
	
	sender.enabled = NO;
	
	[sender.spinner startAnimating];
	
	if(sender.delegate) {
		[self.delegate tappedAudioButton:sender];
	}
}

- (void)normalize
{
	[self.spinner stopAnimating];
	
	self.enabled = YES;
}

@end
