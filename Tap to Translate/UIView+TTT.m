//
//  UIView+TTT.m
//  
//
//  Created by Mohamed Marbouh on 2016-06-15.
//
//

#import "UIView+TTT.h"

@implementation UIView (TTT)

- (NSArray*)TTT_allSubviews
{
	NSMutableArray *arr = [[NSMutableArray alloc] init];
	[arr addObject:self];
	
	for(UIView *subview in self.subviews) {
		[arr addObjectsFromArray:(NSArray*)subview.TTT_allSubviews];
	}
	
	return arr;
}

+ (NSArray*)TTT_allSubviews
{
	return [UIApplication sharedApplication].keyWindow.TTT_allSubviews;
}

@end
