//
//  TTTAudioButton.h
//  Tap to Translate
//
//  Created by Mohamed Marbouh on 2016-12-13.
//  Copyright © 2016 Mohamed Marbouh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTTAudioButton;

@protocol TTTAudioButtonDelegate <NSObject>

- (void)tappedAudioButton:(TTTAudioButton*)button;

@end

@interface TTTAudioButton : UIButton

@property(nonatomic) __weak id<TTTAudioButtonDelegate> delegate;

- (void)normalize;

@end
