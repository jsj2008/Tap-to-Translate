//
//  TTTAudioButton.m
//  
//
//  Created by Mohamed Marbouh on 2016-06-12.
//
//

#import "headers/headers.h"

@interface TTTAudioButton ()

@property(nonatomic, retain) UIActivityIndicatorView *spinner;

@end

@implementation TTTAudioButton

- (instancetype)init
{
	if((self = [TTTAudioButton buttonWithType:UIButtonTypeCustom])) {
		self.frame = CGRectMake(0, 0, 25, 25);
		self.tintColor = [TTTComms isInternetAvailable] ? [UIColor colorWithRed:0 green:.478431 blue:1 alpha:1] : [UIColor grayColor];
		
		UIImage *speakerImage = [[TTTAssets sharedInstance] imageNamed:@"qtm_ic_volume_up~iphone"];
		speakerImage = [speakerImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		
		[self addTarget:self action:@selector(tappedButton:) forControlEvents:UIControlEventTouchUpInside];
		[self setImage:speakerImage forState:UIControlStateNormal];
	}
	
	return self;
}

- (void)tappedButton:(TTTAudioButton*)sender
{
	if(!sender.spinner) {
		sender.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		
		[sender addSubview:sender.spinner];
	}
	
	sender.enabled = NO;
	
	[sender.spinner startAnimating];
	
	[self.delegate tappedAudioButton:sender];
}

- (void)normalize
{
	[self.spinner stopAnimating];
	
	self.enabled = YES;
}

@end