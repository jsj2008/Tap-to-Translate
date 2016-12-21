//
//  TTTLanguageNameView.m
//  Tap to Translate
//
//  Created by Mohamed Marbouh on 2016-12-13.
//  Copyright © 2016 Mohamed Marbouh. All rights reserved.
//

#import "Interfaces.h"

#import <AVFoundation/AVFoundation.h>

@interface TTTLanguageNameView ()

@property BOOL isSource;

@property(nonatomic, weak) IBOutlet TTTAudioButton *audioButton;
@property(nonatomic, retain) AVAudioPlayer *audioPlayer;
@property(nonatomic, retain) NSString *language;
@property(nonatomic, weak) IBOutlet UIButton *languageName;
@property(nonatomic, weak) NSDictionary *translation;

@end

@implementation TTTLanguageNameView

- (void)awakeFromNib
{
	[super awakeFromNib];
	
	UIFont *robotoFont = [UIFont fontWithName:@"Roboto-Regular" size:16];
	
	self.languageName.titleLabel.font = robotoFont;
	
	[self.languageName setTitleColor:UIColor.grayColor forState:UIControlStateNormal];
}

- (void)configureForTranslation:(NSDictionary*)translation isInput:(BOOL)flag
{
	self.audioButton.delegate = self;
	self.isSource = flag;
	
	[self updateTranslation:translation wasAutomatic:flag];
}

- (void)updateTranslation:(NSDictionary*)translation wasAutomatic:(BOOL)flag
{
	self.language = self.isSource ? translation[@"sourceLanguage"] : translation[@"targetLanguage"];
	self.translation = translation;
	
	NSString *langName = [TTTDeviceInfo displayNameForLanguageCode:self.language];
	NSString *text = flag ? [NSString stringWithFormat:TTTString("label_auto_detected_lang"), langName.UTF8String] : langName;
	text = [text stringByAppendingString:@" ▼"];
	
	[self.languageName setTitle:text forState:UIControlStateNormal];
}

- (IBAction)tappedAudioButton:(TTTAudioButton*)button
{
	if([TTTComms isInternetAvailable]) {
		NSString *text = self.isSource ? self.translation[@"sourceText"] : self.translation[@"targetText"];
		
		[TTTComms requestTextToSpeechForText:text language:self.language isSource:self.isSource completion:^(NSData *data) {
			self.audioPlayer = [AVAudioPlayer.alloc initWithData:data error:NULL];
			[self.audioPlayer play];
			[button normalize];
		}];
	} else {
		[button normalize];
		UIAlertController *alert = [UIAlertController alertControllerWithTitle:TTTString("ERROR_MESSAGEBOX_TITLE_NETWORK_ERROR")
																	   message:TTTString("MESSAGEBOX_TTS_NETWORK_FAILED")
																preferredStyle:UIAlertControllerStyleAlert];
		[alert addAction:[UIAlertAction actionWithTitle:TTTString("OK_BUTTON_LABEL") style:UIAlertActionStyleCancel handler:nil]];
		[UIApplication.sharedApplication.keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
	}
}

@end
