//
//  TTTCopyingOptionsDataSource.m
//  
//
//  Created by Mohamed Marbouh on 2016-06-15.
//
//

#import "headers/headers.h"

@interface TTTCopyingOptionsDataSource ()

@property(nonatomic, retain) NSArray *options;
@property(nonatomic, retain) NSMutableDictionary *reusableCells;

@end

@implementation TTTCopyingOptionsDataSource

- (instancetype)init
{
	if((self = [super init])) {
		self.options = @[TTTString("label_copy"), TTTString("label_copydrop_overflow_open_in_main_app")];
		self.reusableCells = [NSMutableDictionary dictionary];
	}
	
	return self;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
	UITableViewCell *cell;
	NSInteger index = indexPath.row;
	
	if([self.reusableCells.allKeys containsObject:@(index)]) {
		cell = self.reusableCells[@(index)];
	} else {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
		cell.backgroundColor = [UIColor clearColor];
		cell.textLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:16];
		
		self.reusableCells[@(index)] = cell;
	}
	
	cell.textLabel.text = self.options[index];
	
	return cell;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.options.count;
}

@end
