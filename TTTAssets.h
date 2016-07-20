//
//  TTTAssets.h
//  
//
//  Created by Mohamed Marbouh on 2016-06-10.
//
//

#import <UIKit/UIKit.h>

@interface TTTAssets : NSObject

+ (instancetype)sharedInstance;
+ (UIImage*)resizeImage:(UIImage*)source newSize:(CGSize)newSize;
- (UIImage*)imageNamed:(NSString*)name;
- (void)prepareFontIfNecessary;

@end
