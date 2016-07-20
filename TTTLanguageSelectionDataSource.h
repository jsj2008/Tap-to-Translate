//
//  TTTLanguageSelectionDataSource.h
//  
//
//  Created by Mohamed Marbouh on 2016-06-15.
//
//

#import <UIKit/UIKit.h>

@interface TTTLanguageSelectionDataSource : NSObject <UITableViewDataSource>

- (instancetype)initWithLanguages:(NSArray*)languages;

@end