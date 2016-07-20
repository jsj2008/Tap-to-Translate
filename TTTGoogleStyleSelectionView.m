//
//  TTTGoogleStyleSelectionView.m
//  
//
//  Created by Mohamed Marbouh on 2016-06-13.
//
//

#import "headers/headers.h"

@implementation TTTGoogleStyleSelectionView

- (instancetype)init
{
	if((self = [super init])) {
		self.backgroundColor = [UIColor colorWithRed:.92 green:.92 blue:.92 alpha:1];
	}
	
	return self;
}

- (void)removeFromSuperview
{
	self.visible = NO;
	
	[super removeFromSuperview];
}

@end
