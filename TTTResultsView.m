//
//  TTTResultsView.m
//  
//
//  Created by Mohamed Marbouh on 2016-06-10.
//
//

#import "headers/headers.h"
#import <RevMobAds/RevMobAds.h>

@interface TTTResultsView ()

@property BOOL editing;
@property NSInteger type;

@property(nonatomic, retain) UIButton *closeButton;
@property(nonatomic, retain) TTTContentSeparatorView *contentSeparator;
@property(nonatomic, retain) TTTGoogleStyleButton *copyingButton;
@property(nonatomic, retain) TTTGoogleLogoHeaderview *logoHeaderView;
@property(nonatomic, retain) TTTGoogleStyleButton *translationButton;
@property(nonatomic, retain) TTTResultTextContentView *resultTextView;
@property(nonatomic, retain) TTTSourceTextContentView *sourceView;
@property(nonatomic, retain) NSDictionary *translation;

@property(nonatomic, retain) TTTGoogleStyleSelectionView *languageSelectionView;
@property(nonatomic, retain) TTTLanguageSelectionDataSource *languagesDataSource;
@property(nonatomic, retain) TTTLanguageSelectionDelegate *languagesDelegate;

@property(nonatomic, retain) TTTGoogleStyleSelectionView *copyingOptionsSelectionView;
@property(nonatomic, retain) TTTCopyingOptionsDataSource *copyingOptionsDataSource;
@property(nonatomic, retain) TTTCopyingOptionsDelegate *copyingOptionsDelegate;

@property(nonatomic, retain) id translationBackup;

@end

@implementation TTTResultsView

- (instancetype)initWithTranslation:(NSDictionary*)translation
{
	if((self = [super init])) {
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(applicationWillResign:)
													 name:UIApplicationWillResignActiveNotification
												   object:nil];
		
		const CGRect windowFrame = [UIApplication sharedApplication].keyWindow.frame;
		
		self.backgroundColor = [UIColor whiteColor];
		self.frame = CGRectMake(20, 50, CGRectGetWidth(windowFrame)-40, CGRectGetHeight(windowFrame)/2);
		self.translation = translation;
		
		UIImage *closeImage = [[TTTAssets sharedInstance] imageNamed:@"goo_ic_close~iphone"];
		closeImage = [TTTAssets resizeImage:closeImage newSize:CGSizeMake(30, 30)];
		closeImage = [closeImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		
		self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
		self.closeButton.tintColor = [UIColor grayColor];
		
		self.logoHeaderView = [[TTTGoogleLogoHeaderview alloc] initWithFrame:CGRectMake(20, 5, CGRectGetWidth(self.frame)-40, 44)];
		
		self.sourceView = [[TTTSourceTextContentView alloc] initWithTranslation:self.translation textContainerSize:CGSizeMake(CGRectGetWidth(self.frame)-60, CGRectGetHeight(self.frame)/6)];
		self.sourceView.languageNameView.languageSelectionDelegate = self;
		self.sourceView.textView.delegate = self;
		
		self.contentSeparator = [[TTTContentSeparatorView alloc] init];
		
		self.resultTextView = [[TTTResultTextContentView alloc] initWithTranslation:self.translation textContainerSize:self.sourceView.containerSize];
		self.resultTextView.languageNameView.languageSelectionDelegate = self;
		
		self.copyingButton = [[TTTGoogleStyleButton alloc] initWithTitleKey:"copy_btn_text"];
		
		self.translationButton = [[TTTGoogleStyleButton alloc] initWithTitleKey:"copydrop_new_translation_button"];
		self.translationButton.visible = YES;
		
		[self.resultTextView.dotsButton addTarget:self action:@selector(tappedCopyDotsButton) forControlEvents:UIControlEventTouchUpInside];
		
		[self.copyingButton addTarget:self action:@selector(tappedCopyButton) forControlEvents:UIControlEventTouchUpInside];
		[self.translationButton addTarget:self action:@selector(tappedNewTranslationButton) forControlEvents:UIControlEventTouchUpInside];
		
		[self.closeButton addTarget:self action:@selector(tappedCloseButton) forControlEvents:UIControlEventTouchUpInside];
		[self.closeButton setImage:closeImage forState:UIControlStateNormal];
		
		[self addSubview:self.logoHeaderView];
		[self addSubview:self.closeButton];
		[self addSubview:self.sourceView];
		[self addSubview:self.contentSeparator];
		[self addSubview:self.resultTextView];
		[self addSubview:self.translationButton];
	}
	
	return self;
}

- (void)setBlurView:(UIVisualEffectView*)blurView
{
	_blurView = blurView;
	
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnbBlurView)];
	[_blurView addGestureRecognizer:tap];
}

- (void)applicationWillResign:(id)info
{
	[self tappedCloseButton];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGRect sourceViewFrame = self.sourceView.frame;
	sourceViewFrame.origin = CGPointMake(30, CGRectGetMaxY(self.logoHeaderView.frame)+25);
	self.sourceView.frame = sourceViewFrame;
	
	self.contentSeparator.frame = CGRectMake(CGRectGetMinX(self.sourceView.frame), CGRectGetMaxY(self.sourceView.frame)+10, CGRectGetWidth(self.sourceView.frame), .7);
	
	CGRect resultViewFrame = self.resultTextView.frame;
	resultViewFrame.origin = CGPointMake(CGRectGetMinX(self.sourceView.frame), CGRectGetMaxY(self.contentSeparator.frame)+10);
	self.resultTextView.frame = resultViewFrame;
	
	CGFloat padding = (CGRectGetWidth(self.frame)-CGRectGetWidth(self.sourceView.frame))/2;
	
	self.closeButton.frame = CGRectMake(CGRectGetWidth(self.frame)-30-padding, 15, 30, 30);
	
	CGRect buttonFrame = CGRectZero;
	
	if(self.translationButton.visible) {
		buttonFrame = self.translationButton.frame;
	} else if(self.copyingButton.visible) {
		buttonFrame = self.copyingButton.frame;
	}
	
	buttonFrame.origin = CGPointMake(CGRectGetWidth(self.frame)-CGRectGetWidth(buttonFrame)-padding, CGRectGetHeight(self.frame)-CGRectGetHeight(buttonFrame)-15);
	
	if(!CGRectEqualToRect(buttonFrame, CGRectZero)) {
		if(self.translationButton.visible) {
			self.translationButton.frame = buttonFrame;
		} else if(self.copyingButton.visible) {
			self.copyingButton.frame = buttonFrame;
		}
	}
}

- (void)tappedCloseButton
{
	[self compressIntoView:^{
		self.blurView.hidden = YES;
		
		[instance.blurView removeFromSuperview];
		[instance removeFromSuperview];
	}];
}

- (void)changeTranslationKey:(NSString*)key toValue:(NSString*)value
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	
	NSMutableDictionary *request = [NSMutableDictionary dictionaryWithDictionary:self.translation];
	request[key] = value;
	
	dispatch_async(dispatch_get_main_queue(), ^{
		[TTTComms requestTranslation:request completion:^(NSDictionary *result) {
			[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
			
			if(self.languageSelectionView.visible) {
				[self.languageSelectionView removeFromSuperview];
			}
			
			self.translation = result;
			
			self.sourceView.textView.text = self.translation[@"sourceText"];
			self.resultTextView.textView.text = self.translation[@"targetText"];
			
			BOOL detectLanguage = [key isEqualToString:@"sourceLanguage"] && [value isEqualToString:@"auto"];
			
			[self.sourceView.languageNameView updateTranslation:self.translation wasAutomatic:detectLanguage];
			[self.resultTextView.languageNameView updateTranslation:self.translation wasAutomatic:NO];
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
}

- (CGRect)languageSelectionViewFrameIfIsInput:(BOOL)input
{
	CGFloat x = self.sourceView.languageNameView.center.x;
	CGFloat y = input ? CGRectGetMinY(self.sourceView.frame) : CGRectGetMinY(self.resultTextView.frame);
	y += CGRectGetHeight(self.sourceView.languageNameView.frame);
	CGFloat width = CGRectGetWidth(self.frame)-CGRectGetMinX(self.sourceView.frame)-x;
	CGFloat height = CGRectGetHeight([UIApplication sharedApplication].keyWindow.frame);
	height -= input ? CGRectGetMaxY(self.sourceView.frame) : CGRectGetMaxY(self.resultTextView.frame);
	
	return CGRectMake(x, y, width, height);
}

- (void)tappedLanguageButton:(id)sender isInput:(BOOL)input
{
	if(self.languageSelectionView.visible) {
		[self.languageSelectionView removeFromSuperview];
	} else {
		[TTTComms requestAvailableLanguages:^(NSArray *languages) {
			NSMutableArray *array = [NSMutableArray arrayWithArray:languages];
			
			if(input) {
				[array insertObject:@[@"auto", TTTString("twslang_auto")] atIndex:0];
			}
			
			self.languagesDataSource = [[TTTLanguageSelectionDataSource alloc] initWithLanguages:array];
			self.languagesDelegate = [[TTTLanguageSelectionDelegate alloc] initWithLanguages:array];
			
			self.languageSelectionView = [[TTTGoogleStyleSelectionView alloc] init];
			self.languageSelectionView.dataSource = self.languagesDataSource;
			self.languageSelectionView.delegate = self.languagesDelegate;
			self.languageSelectionView.frame = [self convertRect:[self languageSelectionViewFrameIfIsInput:input] toView:[UIApplication sharedApplication].keyWindow];
			self.languageSelectionView.isInput = input;
			self.languageSelectionView.visible = YES;
			
			[[UIApplication sharedApplication].keyWindow addSubview:self.languageSelectionView];
		}];
	}
}

- (void)tappedNewTranslationButton
{
	[self.sourceView.textView setEditable:YES];
	[self.sourceView.textView becomeFirstResponder];
}

- (void)tappedCopyButton
{
	[TapToTranslate changeHookingStatus:NO];
	
	[UIPasteboard generalPasteboard].string = self.translation[@"targetText"];
	
	[TapToTranslate changeHookingStatus:NO];
	
	[self tappedCloseButton];
}

- (void)removeFromSuperview
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	if(self.languageSelectionView.visible) {
		[self.languageSelectionView removeFromSuperview];
	}
	
	if(self.copyingOptionsSelectionView.visible) {
		[self.copyingOptionsSelectionView removeFromSuperview];
	}
	
	[super removeFromSuperview];
}

- (void)textViewDidBeginEditing:(UITextView*)textView
{
	self.editing = YES;
	
	if(self.translationButton.visible) {
		textView.text = @"";
	}
	
	[self.translationButton removeFromSuperview];
}

- (void)textViewDidEndEditing:(UITextView*)textView
{
	self.editing = NO;
}

- (void)textViewDidChange:(UITextView*)textView
{
	if(!self.copyingButton.visible) {
		[self addSubview:self.copyingButton];
		self.copyingButton.visible = YES;
	}
	
	[self changeTranslationKey:@"sourceText" toValue:textView.text];
}

- (CGRect)frameForCopyingOptionsView
{
	CGRect frame = self.copyingOptionsSelectionView.frame;
	frame.origin.x = CGRectGetMinX(self.resultTextView.dotsButton.frame)-100;
	frame.origin.y = CGRectGetMinY(self.resultTextView.frame)+CGRectGetMaxY(self.resultTextView.dotsButton.frame);
	frame.size.width = CGRectGetWidth(self.frame)-CGRectGetMinX(self.resultTextView.frame)-CGRectGetWidth(self.resultTextView.dotsButton.frame)*5;
	frame.size.height = CGRectGetHeight(self.frame)-CGRectGetMinY(frame)+10;
	
	return frame;
}

- (void)tappedCopyDotsButton
{
	self.copyingOptionsDataSource = [[TTTCopyingOptionsDataSource alloc] init];
	self.copyingOptionsDelegate = [[TTTCopyingOptionsDelegate alloc] init];
	
	self.copyingOptionsSelectionView = [[TTTGoogleStyleSelectionView alloc] init];
	self.copyingOptionsSelectionView.dataSource = self.copyingOptionsDataSource;
	self.copyingOptionsSelectionView.delegate = self.copyingOptionsDelegate;
	self.copyingOptionsSelectionView.frame = [self convertRect:[self frameForCopyingOptionsView] toView:[UIApplication sharedApplication].keyWindow];
	self.copyingOptionsSelectionView.tableFooterView = [[UIView alloc] init];
	self.copyingOptionsSelectionView.visible = YES;
	
	[[UIApplication sharedApplication].keyWindow addSubview:self.copyingOptionsSelectionView];
}

- (void)openTranslationInApp
{
	NSString *string = [NSString stringWithFormat:@"googleTranslate://translate?sl=%@&tl=%@&text=%@", self.translation[@"sourceLanguage"], self.translation[@"targetLanguage"], self.translation[@"sourceText"]];
	NSURL *url = [NSURL URLWithString:[string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
	[[UIApplication sharedApplication] openURL:url];
}

- (void)handleTapOnbBlurView
{
	if(self.languageSelectionView.visible) {
		[self.languageSelectionView removeFromSuperview];
	} else if(self.copyingOptionsSelectionView.visible) {
		[self.copyingOptionsSelectionView removeFromSuperview];
	} else if(self.editing) {
		[self.sourceView.textView resignFirstResponder];
	} else {
		[self tappedCloseButton];
	}
}

- (void)didAddSubview:(id)subview
{
	if([subview isKindOfClass:TTTGoogleStyleSelectionView.class] ||
	   [subview isKindOfClass:TTTGoogleStyleButton.class]) {
		[subview setVisible:YES];
	}
}

@end