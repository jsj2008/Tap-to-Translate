//
//  TTTComms.h
//  Tap to Translate
//
//  Created by Mohamed Marbouh on 2016-12-13.
//  Copyright © 2016 Mohamed Marbouh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTTComms : NSObject

+ (BOOL)isInternetAvailable;
+ (void)requestAvailableLanguages:(void(^)(NSArray*))block;
+ (void)requestTextToSpeechForText:(NSString*)text language:(NSString*)language isSource:(BOOL)source completion:(void(^)(NSData*))block;
+ (void)requestTranslation:(NSDictionary*)request completion:(void(^)(NSDictionary*))block;
+ (void)requestTranslationForText:(NSString*)text completion:(void(^)(NSDictionary*))block;
+ (void)setupCallbacksForCurrentApplication;
+ (void)setupCallbacksForSpringBoard;
+ (void)setupCallbacksForGoogleTranslate;

@end
