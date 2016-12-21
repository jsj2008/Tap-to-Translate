//
//  TTTGoogleStyleButton.m
//  Tap to Translate
//
//  Created by Mohamed Marbouh on 2016-12-13.
//  Copyright © 2016 Mohamed Marbouh. All rights reserved.
//

#import "Interfaces.h"

@implementation TTTGoogleStyleButton

- (void)awakeFromNib
{
	[super awakeFromNib];
	
	self.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
	self.titleLabel.font = [UIFont fontWithName:@"ProductSans-Regular" size:16];
	
	[self setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
	
	self.layer.cornerRadius = 2.5;
}

- (void)configureWithTitle:(NSString*)title
{
	[self setTitle:TTTString(title.UTF8String).uppercaseString forState:UIControlStateNormal];
}

@end
