//
//  TTTDeviceInfo.m
//  Tap to Translate
//
//  Created by Mohamed Marbouh on 2016-12-13.
//  Copyright © 2016 Mohamed Marbouh. All rights reserved.
//

#import "TTTDeviceInfo.h"

@implementation TTTDeviceInfo

+ (NSString*)currentLanguage
{
	return [NSLocale.preferredLanguages.firstObject componentsSeparatedByString:@"-"].firstObject;
}

+ (NSString*)displayNameForLanguageCode:(NSString*)language
{
	NSLocale *locale = [NSLocale localeWithLocaleIdentifier:self.currentLanguage];
	return [locale displayNameForKey:NSLocaleIdentifier value:language].uppercaseString;
}

@end
