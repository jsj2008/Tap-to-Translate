//
//  TTTResultsView.h
//  
//
//  Created by Mohamed Marbouh on 2016-06-10.
//
//

#import <UIKit/UIKit.h>
#import "UIView+DCAnimationKit.h"

@interface TTTResultsView : UIView <TTTLanguageSelectionDelegate, UITextViewDelegate>

@property(nonatomic) __weak UIVisualEffectView *blurView;

- (instancetype)initWithTranslation:(NSDictionary*)translation;

@end
