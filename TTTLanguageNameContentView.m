//
//  TTTLanguageNameContentView.m
//  
//
//  Created by Mohamed Marbouh on 2016-06-11.
//
//

#import "headers/headers.h"
#import <AVFoundation/AVFoundation.h>

@interface TTTLanguageNameContentView ()

@property BOOL isSource;

@property(nonatomic, retain) TTTAudioButton *audioButton;
@property(nonatomic, retain) AVAudioPlayer *audioPlayer;
@property(nonatomic, retain) NSString *language;
@property(nonatomic, retain) UIButton *languageName;
@property(nonatomic) __weak NSDictionary *translation;

@end

@implementation TTTLanguageNameContentView

- (instancetype)initWithTranslation:(NSDictionary*)translation isInput:(BOOL)flag
{
	if((self = [super init])) {
		self.isSource = flag;
		self.translation = translation;
		self.language = flag ? translation[@"sourceLanguage"] : translation[@"targetLanguage"];
		
		self.audioButton = [[TTTAudioButton alloc] init];
		self.audioButton.delegate = self;
		
		NSString *langName = [TTTDeviceInfo displayNameForLanguageCode:self.language];
		
		UIFont *robotoFont = [UIFont fontWithName:@"Roboto-Regular" size:16];
		
		self.languageName = [UIButton buttonWithType:UIButtonTypeCustom];
		self.languageName.titleLabel.font = robotoFont;
		
		NSString *text = flag ? [NSString stringWithFormat:TTTString("label_auto_detected_lang"), langName.UTF8String] : langName;
		text = [text stringByAppendingString:@" ▼"];
		
		[self.languageName addTarget:self action:@selector(tappedLanguageButton:) forControlEvents:UIControlEventTouchUpInside];
		[self.languageName setTitle:text forState:UIControlStateNormal];
		[self.languageName setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
		
		CGRect languageNameFrame = self.languageName.frame;
		languageNameFrame.origin = CGPointMake(CGRectGetMaxX(self.audioButton.frame)+10, CGRectGetMinY(self.audioButton.frame)-3);
		self.languageName.frame = languageNameFrame;
		
		[self.languageName sizeToFit];
		
		[self addSubview:self.audioButton];
		[self addSubview:self.languageName];
		
		self.frame = CGRectMake(0, 0, CGRectGetMaxX(self.languageName.frame), CGRectGetHeight(self.languageName.frame));
	}
	
	return self;
}

- (void)tappedAudioButton:(TTTAudioButton*)button
{
	if([TTTComms isInternetAvailable]) {
		NSString *text = self.isSource ? self.translation[@"sourceText"] : self.translation[@"targetText"];
		
		[TTTComms requestTextToSpeechForText:text language:self.language isSource:self.isSource completion:^(NSData *data) {
			self.audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:NULL];
			[self.audioPlayer play];
			[button normalize];
		}];
	} else {
		[button normalize];
		UIAlertController *alert = [UIAlertController alertControllerWithTitle:TTTString("ERROR_MESSAGEBOX_TITLE_NETWORK_ERROR")
																	   message:TTTString("MESSAGEBOX_TTS_NETWORK_FAILED")
																preferredStyle:UIAlertControllerStyleAlert];
		[alert addAction:[UIAlertAction actionWithTitle:TTTString("OK_BUTTON_LABEL") style:UIAlertActionStyleCancel handler:nil]];
		[[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
	}
}

- (void)tappedLanguageButton:(id)sender
{
	[self.languageSelectionDelegate tappedLanguageButton:sender isInput:self.isSource];
}

- (void)updateTranslation:(NSDictionary*)translation wasAutomatic:(BOOL)flag
{
	self.translation = translation;
	self.language = self.isSource ? translation[@"sourceLanguage"] : translation[@"targetLanguage"];
	
	NSString *langName = [TTTDeviceInfo displayNameForLanguageCode:self.language];
	
	NSString *text = flag ? [NSString stringWithFormat:TTTString("label_auto_detected_lang"), langName.UTF8String] : langName;
	text = [text stringByAppendingString:@" ▼"];
	
	[self.languageName setTitle:text forState:UIControlStateNormal];
	[self.languageName sizeToFit];
	
	self.frame = CGRectMake(0, 0, CGRectGetMaxX(self.languageName.frame), CGRectGetHeight(self.languageName.frame));
}

@end
