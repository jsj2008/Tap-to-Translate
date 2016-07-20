//
//  TTTDeviceInfo.h
//  
//
//  Created by Mohamed Marbouh on 2016-06-12.
//
//

#import <Foundation/Foundation.h>

@interface TTTDeviceInfo : NSObject

+ (NSString*)currentLanguage;
+ (NSString*)displayNameForLanguageCode:(NSString*)language;

@end
