//
//  TTTDeviceInfo.m
//  
//
//  Created by Mohamed Marbouh on 2016-06-12.
//
//

#import "TTTDeviceInfo.h"

@implementation TTTDeviceInfo

+ (NSString*)currentLanguage
{
	return [[NSLocale preferredLanguages][0] componentsSeparatedByString:@"-"][0];
}

+ (NSString*)displayNameForLanguageCode:(NSString*)language
{
	NSLocale *locale = [NSLocale localeWithLocaleIdentifier:[self currentLanguage]];
	return [locale displayNameForKey:NSLocaleIdentifier value:language].uppercaseString;
}

@end
