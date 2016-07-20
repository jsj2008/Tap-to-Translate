//
//  TTTLocalizations.h
//  
//
//  Created by Mohamed Marbouh on 2016-06-12.
//
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface TTTLocalizations : NSObject

+ (TTTLocalizations*)sharedInstance;
+ (NSString*)string:(NSString*)key;

@end

inline NSString *TTTString(const char *key)
{
	return [objc_getClass("TTTLocalizations") string:[NSString stringWithUTF8String:key]];
}