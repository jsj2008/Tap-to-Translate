//
//  TTTPrefs.m
//  
//
//  Created by Mohamed Marbouh on 2016-06-16.
//
//

#import "TTTPrefs.h"

@implementation TTTPrefs

+ (NSDictionary*)defaults
{
	static NSDictionary *defaultPreferences = nil;
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		defaultPreferences = @{@"UDID": @""};
	});
	
	return defaultPreferences;
}

+ (void)setValue:(id)value forKey:(id)key
{
	CFPreferencesAppSynchronize(CFSTR("com.mootjeuh.taptotranslate"));
	CFPreferencesSetAppValue((__bridge CFStringRef)key, (__bridge CFPropertyListRef)value, CFSTR("com.mootjeuh.taptotranslate"));
	CFPreferencesAppSynchronize(CFSTR("com.mootjeuh.taptotranslate"));
}

+ (id)getPreferenceForKey:(id)key
{
	CFPreferencesAppSynchronize(CFSTR("com.mootjeuh.taptotranslate"));
	id value = (__bridge id)CFPreferencesCopyAppValue((__bridge CFStringRef)key, CFSTR("com.mootjeuh.taptotranslate"));
	
	return value ? : [self defaults][key];
}

@end
