//
//  TTTResultTextContentView.m
//  
//
//  Created by Mohamed Marbouh on 2016-06-12.
//
//

#import "headers/headers.h"

@interface TTTResultTextContentView ()

@end

@implementation TTTResultTextContentView

- (instancetype)initWithTranslation:(NSDictionary*)translation textContainerSize:(CGSize)size
{
	if((self = [super init])) {
		self.languageNameView = [[TTTLanguageNameContentView alloc] initWithTranslation:translation isInput:NO];
		
		UIFont *robotoFont = [UIFont fontWithName:@"Roboto-Regular" size:22];
		
		self.textView = [[UITextView alloc] init];
		self.textView.editable = NO;
		self.textView.font = robotoFont;
		self.textView.frame = CGRectMake(0, CGRectGetMaxY(self.languageNameView.frame)+5, size.width, size.height);
		self.textView.text = translation[@"targetText"];
		self.textView.textColor = [UIColor colorWithRed:0 green:.478431 blue:1 alpha:1];
		
		UIImage *dots = [[TTTAssets sharedInstance] imageNamed:@"goo_ic_more_vert~iphone"];
		dots = [dots imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		
		self.dotsButton = [UIButton buttonWithType:UIButtonTypeCustom];
		self.dotsButton.tintColor = [UIColor grayColor];
		
		[self.dotsButton setImage:dots forState:UIControlStateNormal];
		
		CGRect frame = self.dotsButton.frame;
		frame.origin = CGPointMake(size.width-5, (size.height+CGRectGetHeight(self.languageNameView.frame)+5)/2);
		frame.size = CGSizeMake(30, 30);
		self.dotsButton.frame = frame;
		
		[self addSubview:self.languageNameView];
		[self addSubview:self.textView];
		[self addSubview:self.dotsButton];
		
		self.frame = CGRectMake(0, 0, size.width+dots.size.width-5, size.height+CGRectGetHeight(self.languageNameView.frame)+5);
	}
	
	return self;
}

@end