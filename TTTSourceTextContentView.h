//
//  TTTSourceTextContentView.h
//  
//
//  Created by Mohamed Marbouh on 2016-06-11.
//
//

#import <UIKit/UIKit.h>

@interface TTTSourceTextContentView : UIView

@property CGSize containerSize;

@property(nonatomic, retain) TTTLanguageNameContentView *languageNameView;
@property(nonatomic, retain) UITextView *textView;

- (instancetype)initWithTranslation:(NSDictionary*)translation textContainerSize:(CGSize)size;

@end