//
//  TTTResultTextContentView
//  
//
//  Created by Mohamed Marbouh on 2016-06-12.
//
//

#import <UIKit/UIKit.h>

@interface TTTResultTextContentView : UIView

@property(nonatomic, retain) UIButton *dotsButton;
@property(nonatomic, retain) TTTLanguageNameContentView *languageNameView;
@property(nonatomic, retain) UITextView *textView;

- (instancetype)initWithTranslation:(NSDictionary*)translation textContainerSize:(CGSize)size;

@end