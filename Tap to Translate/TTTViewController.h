//
//  TTTViewController.h
//  Tap to Translate
//
//  Created by Mohamed Marbouh on 2016-12-13.
//  Copyright © 2016 Mohamed Marbouh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTTViewController : UIViewController

@property(nonatomic) NSDictionary *translation;

- (void)changeInputLanguageTo:(NSString*)language;
- (void)changeTargetLanguageTo:(NSString*)language;

@end

