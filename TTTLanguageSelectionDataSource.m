//
//  TTTLanguageSelectionDataSource.m
//  
//
//  Created by Mohamed Marbouh on 2016-06-15.
//
//

#import "TTTLanguageSelectionDataSource.h"

@interface TTTLanguageSelectionDataSource ()

@property(nonatomic, retain) NSArray *languages;
@property(nonatomic, retain) NSMutableDictionary *reusableCells;

@end

@implementation TTTLanguageSelectionDataSource

- (instancetype)initWithLanguages:(NSArray*)languages
{
	if((self = [super init])) {
		self.languages = languages;
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
	
	cell.textLabel.text = self.languages[index][1];
	
	return cell;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.languages.count;
}

@end
