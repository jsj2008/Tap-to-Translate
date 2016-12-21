//
//  TTTDeviceInfo.h
//  Tap to Translate
//
//  Created by Mohamed Marbouh on 2016-12-13.
//  Copyright © 2016 Mohamed Marbouh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTTDeviceInfo : NSObject

+ (NSString*)currentLanguage;
+ (NSString*)displayNameForLanguageCode:(NSString*)language;

@end
