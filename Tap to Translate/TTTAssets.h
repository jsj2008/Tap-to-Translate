//
//  TTTAssets.h
//  Tap to Translate
//
//  Created by Mohamed Marbouh on 2016-12-13.
//  Copyright © 2016 Mohamed Marbouh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTTAssets : NSObject

+ (instancetype)sharedInstance;
+ (UIImage*)resizeImage:(UIImage*)source newSize:(CGSize)newSize;
- (UIImage*)imageNamed:(NSString*)name;
- (void)prepareFontIfNecessary;

@end
