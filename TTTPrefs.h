//
//  TTTPrefs.h
//  
//
//  Created by Mohamed Marbouh on 2016-06-16.
//
//

#import <Foundation/Foundation.h>

@interface TTTPrefs : NSObject

+ (void)setValue:(id)value forKey:(id)key;
+ (id)getPreferenceForKey:(id)key;

@end
