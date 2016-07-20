//
//  TTTSourceTextContentView.m
//  
//
//  Created by Mohamed Marbouh on 2016-06-11.
//
//

#import "headers/headers.h"

@interface TTTSourceTextContentView ()

@end

@implementation TTTSourceTextContentView

- (instancetype)initWithTranslation:(NSDictionary*)translation textContainerSize:(CGSize)size
{
	if((self = [super init])) {
		self.containerSize = size;
		self.languageNameView = [[TTTLanguageNameContentView alloc] initWithTranslation:translation isInput:YES];
		
		UIFont *robotoFont = [UIFont fontWithName:@"Roboto-Regular" size:22];
		self.textView = [[UITextView alloc] init];
		
		self.textView.editable = NO;
		self.textView.font = robotoFont;
		self.textView.frame = CGRectMake(0, CGRectGetMaxY(self.languageNameView.frame)+5, size.width, size.height);
		self.textView.text = translation[@"sourceText"];
		
		[self addSubview:self.languageNameView];
		[self addSubview:self.textView];
		
		self.frame = CGRectMake(0, 0, size.width, size.height+CGRectGetHeight(self.languageNameView.frame)+5);
	}
	
	return self;
}

@end