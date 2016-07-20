//
//  TTTContentSeparatorView.m
//  
//
//  Created by Mohamed Marbouh on 2016-06-11.
//
//

#import "headers/headers.h"

@implementation TTTContentSeparatorView

- (instancetype)init
{
	if((self = [super init])) {
		self.alpha = .6;
		self.backgroundColor = [UIColor lightGrayColor];
	}
	
	return self;
}

@end