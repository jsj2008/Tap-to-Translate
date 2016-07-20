//
//  TapToTranslate.h
//  
//
//  Created by Mohamed Marbouh on 2016-06-15.
//
//

#import <Foundation/Foundation.h>

@interface TapToTranslate : NSObject

+ (void)prepareWindowWithTranslation:(NSDictionary*)translation;
+ (void)showWindowIfPrepared;
+ (void)updateLanguage:(NSString*)language isInput:(BOOL)input;
+ (BOOL)hooksEnabled;
+ (void)changeHookingStatus:(BOOL)shouldHook;
+ (void)copyTextAndExit;
+ (void)openInGoogleTranslateApp;

@end
