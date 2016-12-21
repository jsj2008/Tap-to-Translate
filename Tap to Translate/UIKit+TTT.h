//
//  UIKit.h
//  
//
//  Created by Mohamed Marbouh on 2016-05-24.
//
//

#ifndef UIKit_h
#define UIKit_h

#import <UIKit/UIKit.h>

@interface UIApplication (TapToTranslate)

- (BOOL)launchApplicationWithIdentifier:(NSString*)arg1 suspended:(BOOL)arg2;

@end

@interface UIViewController (TapToTranslate)

@property(assign, nonatomic) UIViewController *_sourceViewControllerIfPresentedViaPopoverSegue;

@end

#endif /* UIKit_h */
