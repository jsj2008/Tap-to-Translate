//
//  TTTAssets.m
//  
//
//  Created by Mohamed Marbouh on 2016-06-10.
//
//

#import "headers/headers.h"
#import <CoreText/CoreText.h>

@interface TTTAssets ()

@property(nonatomic, retain) NSBundle *bundle;
@property(nonatomic, retain) NSBundle *robotoLoader;

@end

@implementation TTTAssets

+ (instancetype)sharedInstance
{
	static TTTAssets *sharedInstance = nil;
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		sharedInstance = [[self alloc] init];
		sharedInstance.bundle = [NSBundle bundleWithPath:@"/Library/Application Support/Tap to Translate/Assets.bundle"];
		sharedInstance.robotoLoader = [NSBundle bundleWithPath:@"/Library/Application Support/Tap to Translate/MaterialRobotoFontLoader.bundle"];
	});
	
	return sharedInstance;
}

+ (UIImage*)resizeImage:(UIImage*)source newSize:(CGSize)newSize
{
	UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
	[source drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
	UIImage *retVal = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return retVal;
}

+ (void)registerFontNamed:(NSString*)name inBundle:(NSBundle*)bundle
{
	NSData *inData = [NSData dataWithContentsOfFile:[bundle pathForResource:name ofType:@"ttf"]];
	CFErrorRef error;
	CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)inData);
	CGFontRef font = CGFontCreateWithDataProvider(provider);
	
	if(!CTFontManagerRegisterGraphicsFont(font, &error)) {
		CFStringRef errorDescription = CFErrorCopyDescription(error);
		CFRelease(errorDescription);
	}
	
	CFRelease(font);
	CFRelease(provider);
}

- (UIImage*)imageNamed:(NSString*)name
{
	return [UIImage imageNamed:name inBundle:self.bundle compatibleWithTraitCollection:nil];
}

- (void)prepareFontIfNecessary
{
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		[TTTAssets registerFontNamed:@"ProductSans-Regular" inBundle:self.bundle];
		[TTTAssets registerFontNamed:@"Roboto-Regular" inBundle:self.robotoLoader];
	});
}

@end
