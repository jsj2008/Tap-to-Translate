//
//  TTTBubble.h
//  
//
//  Created by Mohamed Marbouh on 2016-05-12.
//
//

#import <UIKit/UIKit.h>

@interface TTTBubble : UIButton

+ (instancetype)sharedInstance;
- (void)positionAccordingToWindow;
- (void)configureForEvents;
- (void)configureForFirstTime:(NSString*)text;
- (void)configureForTranslation:(NSDictionary*)translation;
- (void)configureForNoNetworkError;

@end
