//
//  TTTGoogleStyleButton.m
//  
//
//  Created by Mohamed Marbouh on 2016-06-15.
//
//

#import "headers/headers.h"

@implementation TTTGoogleStyleButton

- (instancetype)initWithTitleKey:(const char*)title
{
	if((self = [TTTGoogleStyleButton buttonWithType:UIButtonTypeCustom])) {
		self.backgroundColor = [UIColor colorWithRed:52.f/255.f green:110.f/255.f blue:242.f/255.f alpha:1];
		self.titleLabel.font = [UIFont fontWithName:@"ProductSans-Regular" size:16];
		
		[self setTitle:TTTString(title).uppercaseString forState:UIControlStateNormal];
		[self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[self sizeToFit];
		
		CGRect frame = self.frame;
		frame.size.width += 10;
		frame.size.height += 10;
		self.frame = frame;
		
		self.layer.cornerRadius = 2.5;
		self.clipsToBounds = YES;
	}
	
	return self;
}

- (void)removeFromSuperview
{
	self.visible = NO;
	
	[super removeFromSuperview];
}

@end
