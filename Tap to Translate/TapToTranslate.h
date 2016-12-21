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
+ (void)closeWindow;
+ (BOOL)hooksEnabled;
+ (void)changeHookingStatus:(BOOL)shouldHook;

@end
