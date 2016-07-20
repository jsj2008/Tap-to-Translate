//
//  TTTAudioButton.h
//  
//
//  Created by Mohamed Marbouh on 2016-06-12.
//
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