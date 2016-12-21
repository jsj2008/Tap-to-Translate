//
//  TTTLocalizations.h
//  Tap to Translate
//
//  Created by Mohamed Marbouh on 2016-12-13.
//  Copyright © 2016 Mohamed Marbouh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface TTTLocalizations : NSObject

+ (NSString*)string:(NSString*)key;

@end

static inline NSString *TTTString(const char *key)
{
	return [objc_getClass("TTTLocalizations") string:[NSString stringWithUTF8String:key]];
}
