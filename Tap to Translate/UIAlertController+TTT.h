//
//  UIAlertController+TTT.h
//  
//
//  Created by Mohamed Marbouh on 2016-07-28.
//
//

#import <Foundation/Foundation.h>

@interface UIAlertController (TTT)

@property(nonatomic, strong) UIWindow *alertWindow;

- (void)show;
- (void)show:(BOOL)animated;

@end
