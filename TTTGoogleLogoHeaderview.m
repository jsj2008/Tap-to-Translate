//
//  TTTGoogleLogoHeaderview.m
//  
//
//  Created by Mohamed Marbouh on 2016-06-10.
//
//

#import "headers/headers.h"

@interface TTTGoogleLogoHeaderview ()

@property(nonatomic, retain) UILabel *label;
@property(nonatomic, retain) UIImageView *view;

@end

@implementation TTTGoogleLogoHeaderview

- (instancetype)initWithFrame:(CGRect)frame
{
	if((self = [super initWithFrame:frame])) {
		UIImage *googleImage = [[TTTAssets sharedInstance] imageNamed:@"googlelogo_color_800x439px.png"];
		googleImage = [TTTAssets resizeImage:googleImage newSize:CGSizeMake(100, 44)];
		
		self.view = [[UIImageView alloc] initWithImage:googleImage];
		self.view.userInteractionEnabled = YES;
		
		UIFont *googleFont = [UIFont fontWithName:@"ProductSans-Regular" size:22];
		
		self.label = [[UILabel alloc] init];
		self.label.font = googleFont;
		self.label.text = @"Translate";
		self.label.textColor = [UIColor grayColor];
		self.label.userInteractionEnabled = YES;
		
		[self.label sizeToFit];
		
		self.view.center = CGPointMake((CGRectGetWidth(frame)/2)-(CGRectGetWidth(self.view.frame)/2), CGRectGetHeight(frame)/2);
		self.label.center = CGPointMake(0, CGRectGetHeight(frame)/2);
		
		CGRect frame = self.label.frame;
		frame.origin.x = CGRectGetMaxX(self.view.frame)+2;
		self.label.frame = frame;
		
		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:TapToTranslate.class action:@selector(openInGoogleTranslateApp)];
		
		[self.view addGestureRecognizer:tap];
		[self.label addGestureRecognizer:tap];
		
		[self addSubview:self.view];
		[self addSubview:self.label];
	}
	
	return self;
}

@end