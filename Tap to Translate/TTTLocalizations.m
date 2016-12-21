//
//  TTTLocalizations.m
//  Tap to Translate
//
//  Created by Mohamed Marbouh on 2016-12-13.
//  Copyright © 2016 Mohamed Marbouh. All rights reserved.
//

#import "TTTLocalizations.h"
#import "XMLDictionary/XMLDictionary.h"

@interface TTTLocalizations ()

@property(nonatomic) NSBundle *bundle;
@property(nonatomic) NSBundle *androidBundle;
@property(nonatomic) NSDictionary *androidStrings;

@end

@implementation TTTLocalizations

+ (TTTLocalizations*)sharedInstance
{
	static TTTLocalizations *sharedInstance = nil;
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		sharedInstance = [self.alloc init];
		sharedInstance.bundle = [NSBundle bundleWithPath:@"/Library/Application Support/Tap to Translate/Strings.bundle"];
		sharedInstance.androidBundle = [NSBundle bundleWithPath:@"/Library/Application Support/Tap to Translate/Android.bundle"];
		
		NSURL *url = [sharedInstance.androidBundle URLForResource:@"strings" withExtension:@"xml"];
		NSDictionary *xml = [NSDictionary dictionaryWithXMLFile:url.path];
		NSMutableDictionary *temp = NSMutableDictionary.dictionary;
		
		if([xml.allKeys containsObject:@"string"]) {
			NSArray *strings = xml[@"string"];
			
			for(NSDictionary *item in strings) {
				if([item.allKeys containsObject:@"_name"] && [item.allKeys containsObject:@"__text"]) {
					temp[item[@"_name"]] = item[@"__text"];
				}
			}
			
			sharedInstance.androidStrings = [NSDictionary dictionaryWithDictionary:temp];
		}
	});
	
	return sharedInstance;
}

+ (NSString*)string:(NSString*)key
{
	return self.sharedInstance.androidStrings[key] ? : [self.sharedInstance.bundle localizedStringForKey:key value:key table:nil];
}

@end
