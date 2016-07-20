//
//  TTTComms.h
//  
//
//  Created by Mohamed Marbouh on 2016-05-24.
//
//

#import <Foundation/Foundation.h>

@interface TTTComms : NSObject <GTRTranslationRequestManagerDelegate>

+ (instancetype)sharedInstance;

+ (void)setupCallbacksForSpringBoard;
+ (void)setupCallbacksForGoogleTranslate;
+ (void)setupCallbacksForCurrentApplication;

+ (BOOL)isInternetAvailable;

+ (void)requestAvailableLanguages:(void(^)(NSArray*))block;
+ (void)requestTranslation:(NSDictionary*)request completion:(void(^)(NSDictionary*))block;
+ (void)requestTranslationForText:(NSString*)text completion:(void(^)(NSDictionary*))block;
+ (void)requestTextToSpeechForText:(NSString*)text language:(NSString*)language isSource:(BOOL)source completion:(void(^)(NSData*))block;

@end
