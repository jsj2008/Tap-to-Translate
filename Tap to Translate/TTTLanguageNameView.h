//
//  TTTLanguageNameView.h
//  Tap to Translate
//
//  Created by Mohamed Marbouh on 2016-12-13.
//  Copyright © 2016 Mohamed Marbouh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTTLanguageNameView : UIView <TTTAudioButtonDelegate>

- (void)configureForTranslation:(NSDictionary*)translation isInput:(BOOL)flag;
- (void)updateTranslation:(NSDictionary*)translation wasAutomatic:(BOOL)flag;

@end
