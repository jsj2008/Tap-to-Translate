//
//  TTTLanguageNameContentView.h
//  
//
//  Created by Mohamed Marbouh on 2016-06-11.
//
//

#import <UIKit/UIKit.h>

@class TTTLanguageSelectionView;

@protocol TTTLanguageSelectionDelegate <NSObject>

- (void)tappedLanguageButton:(id)sender isInput:(BOOL)input;

@end

@interface TTTLanguageNameContentView : UIView <TTTAudioButtonDelegate>

@property(nonatomic) __weak id<TTTLanguageSelectionDelegate> languageSelectionDelegate;

- (instancetype)initWithTranslation:(NSDictionary*)translation isInput:(BOOL)flag;
- (void)updateTranslation:(NSDictionary*)translation wasAutomatic:(BOOL)flag;

@end