//
//  TTTLanguageSelectionDelegate.m
//  
//
//  Created by Mohamed Marbouh on 2016-06-15.
//
//

#import "headers/headers.h"

@interface TTTLanguageSelectionDelegate ()

@property(nonatomic, retain) NSArray *languages;

@end

@implementation TTTLanguageSelectionDelegate

- (instancetype)initWithLanguages:(NSArray*)languages
{
	if((self = [super init])) {
		self.languages = languages;
	}
	
	return self;
}

- (void)tableView:(TTTGoogleStyleSelectionView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	[TapToTranslate updateLanguage:self.languages[indexPath.row][0] isInput:tableView.isInput];
}

@end
