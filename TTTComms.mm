//
//  TTTComms.m
//  
//
//  Created by Mohamed Marbouh on 2016-05-24.
//
//

#import "headers/headers.h"

#import <substrate.h>
#include <netdb.h>
#import <arpa/inet.h>
#import <ifaddrs.h>

static NSString *latestRequestApp = nil;
static void (^globalCompletionBlock)(id) = nil;

@implementation TTTComms

+ (instancetype)sharedInstance
{
	static TTTComms *sharedInstance = nil;
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		sharedInstance = [[self alloc] init];
	});
	
	return sharedInstance;
}

+ (void)setupCallbacksForSpringBoard
{
	[objc_getClass("TTTIPC") registerIncomingMessageFromAppHandlerForMessageName:@"TTT.LaunchAppSuspended" handler:^NSDictionary *(NSDictionary *message) {
		[[UIApplication sharedApplication] launchApplicationWithIdentifier:message[@"id"] suspended:YES];
		
		return nil;
	}];
	
	[objc_getClass("TTTIPC") registerIncomingMessageFromAppHandlerForMessageName:@"TTT.RequestTranslation" handler:^NSDictionary *(NSDictionary *message) {
		[objc_getClass("TTTIPC") sendMessageToAppWithIdentifier:@"com.google.Translate" messageName:@"TTT.RequestTranslation" dictionary:message replyHandler:nil];
		
		return nil;
	}];
	
	[objc_getClass("TTTIPC") registerIncomingMessageFromAppHandlerForMessageName:@"TTT.ReceiveTranslation" handler:^NSDictionary *(NSDictionary *message) {
		[objc_getClass("TTTIPC") sendMessageToAppWithIdentifier:message[@"destination"] messageName:@"TTT.ReceiveTranslation" dictionary:message[@"json"] replyHandler:nil];
		
		return nil;
	}];
	
	[objc_getClass("TTTIPC") registerIncomingMessageFromAppHandlerForMessageName:@"TTT.RequestTextToSpeech" handler:^NSDictionary *(NSDictionary *message) {
		[objc_getClass("TTTIPC") sendMessageToAppWithIdentifier:@"com.google.Translate" messageName:@"TTT.RequestTextToSpeech" dictionary:message replyHandler:nil];
		
		return nil;
	}];
	
	[objc_getClass("TTTIPC") registerIncomingMessageFromAppHandlerForMessageName:@"TTT.ReceiveTextToSpeech" handler:^NSDictionary *(NSDictionary *message) {
		[objc_getClass("TTTIPC") sendMessageToAppWithIdentifier:message[@"destination"] messageName:@"TTT.ReceiveTextToSpeech" dictionary:message replyHandler:nil];
		
		return nil;
	}];
	
	[objc_getClass("TTTIPC") registerIncomingMessageFromAppHandlerForMessageName:@"TTT.RequestAvailableLanguages" handler:^NSDictionary *(NSDictionary *message) {
		[objc_getClass("TTTIPC") sendMessageToAppWithIdentifier:@"com.google.Translate" messageName:@"TTT.RequestAvailableLanguages" dictionary:nil replyHandler:^(NSDictionary *response) {
			[objc_getClass("TTTIPC") sendMessageToAppWithIdentifier:message[@"source"] messageName:@"TTT.ReceiveAvailableLanguages" dictionary:response replyHandler:nil];
		}];
		
		return nil;
	}];
}

+ (void)setupCallbacksForGoogleTranslate
{
	[objc_getClass("TTTIPC") registerIncomingMessageFromSpringBoardHandlerForMessageName:@"TTT.RequestTranslation" handler:^NSDictionary *(NSDictionary *message) {
		latestRequestApp = message[@"source"];
		
		TranslateAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
		NSDictionary *request = [NSDictionary dictionaryWithDictionary:message[@"request"]];
		
		[appDelegate.translateViewController.translationManager setDelegate:[self sharedInstance]];
		[appDelegate.translateViewController.translationManager requestTranslationForText:request[@"sourceText"]
																	   sourceLanguageCode:request[@"sourceLanguage"]
																	   targetLanguageCode:request[@"targetLanguage"]
																	   deviceLanguageCode:[TTTDeviceInfo currentLanguage]
																			  inputMethod:0
																				 OTFState:1];
		
		return nil;
	}];
	
	[objc_getClass("TTTIPC") registerIncomingMessageFromSpringBoardHandlerForMessageName:@"TTT.RequestTextToSpeech" handler:^NSDictionary *(NSDictionary *message) {
		latestRequestApp = message[@"app"];
		
		TranslateAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
		
		[appDelegate.textToSpeechController downloadTTSDataForText:message[@"text"] inLanguage:message[@"language"] textSource:message[@"source"] segmentCount:1 index:0 didFinishSelector:@selector(TTT_fetcher:finishedWithData:error:)];
		
		return nil;
	}];
	
	[objc_getClass("TTTIPC") registerIncomingMessageFromSpringBoardHandlerForMessageName:@"TTT.RequestAvailableLanguages" handler:^NSDictionary *(NSDictionary *message) {
		LanguageSelectionViewController *selectionVC = [[objc_getClass("LanguageSelectionViewController") alloc] init];
		[selectionVC initLanguages];
		
		NSMutableArray *array = [NSMutableArray array];
		
		for(LanguageInfo *language in MSHookIvar<NSArray*>(selectionVC, "_languages")) {
			[array addObject:@[language.code, language.name]];
		}
		
		return @{@"languages": array};
	}];
}

+ (void)setupCallbacksForCurrentApplication
{
	[objc_getClass("TTTIPC") registerIncomingMessageFromSpringBoardHandlerForMessageName:@"TTT.ReceiveTranslation" handler:^NSDictionary *(NSDictionary *message) {
		globalCompletionBlock(message);
		return nil;;
	}];
	
	[objc_getClass("TTTIPC") registerIncomingMessageFromSpringBoardHandlerForMessageName:@"TTT.ReceiveTextToSpeech" handler:^NSDictionary *(NSDictionary *message) {
		globalCompletionBlock(message[@"mp3"]);
		return nil;;
	}];
	
	[objc_getClass("TTTIPC") registerIncomingMessageFromSpringBoardHandlerForMessageName:@"TTT.ReceiveAvailableLanguages" handler:^NSDictionary *(NSDictionary *message) {
		globalCompletionBlock(message[@"languages"]);
		return nil;;
	}];
}

+ (BOOL)isInternetAvailable
{
	struct addrinfo *res = NULL;
	int s = getaddrinfo("translate.google.com", NULL, NULL, &res);
	BOOL network_ok = (s == 0 && res != NULL);
	freeaddrinfo(res);
	
	return network_ok;
}

+ (void)requestTranslationForText:(NSString*)text completion:(void(^)(NSDictionary*))block
{
	globalCompletionBlock = block;
	
	NSDictionary *request = @{@"sourceLanguage": @"auto", @"sourceText": text, @"targetLanguage": [TTTDeviceInfo currentLanguage]};
	
	[self requestTranslation:request completion:block];
}

+ (void)requestTranslation:(NSDictionary*)request completion:(void(^)(NSDictionary*))block
{
	globalCompletionBlock = block;
	
	NSDictionary *info = @{@"source": [NSBundle mainBundle].bundleIdentifier, @"request": request};
	
	[objc_getClass("TTTIPC") sendMessageToSpringBoardWithMessageName:@"TTT.RequestTranslation" dictionary:info replyHandler:nil];
}

+ (void)requestTextToSpeechForText:(NSString*)text language:(NSString*)language isSource:(BOOL)source completion:(void(^)(NSData*))block
{
	globalCompletionBlock = block;
	
	NSDictionary *info = @{@"text": text, @"language": language, @"source": source ? @"input" : @"target", @"app": [NSBundle mainBundle].bundleIdentifier};
	
	[objc_getClass("TTTIPC") sendMessageToSpringBoardWithMessageName:@"TTT.RequestTextToSpeech" dictionary:info replyHandler:nil];
}

+ (void)requestAvailableLanguages:(void(^)(NSArray*))block
{
	globalCompletionBlock = block;
	
	NSDictionary *info = @{@"source": [NSBundle mainBundle].bundleIdentifier};
	
	[objc_getClass("TTTIPC") sendMessageToSpringBoardWithMessageName:@"TTT.RequestAvailableLanguages" dictionary:info replyHandler:nil];
}

- (NSDictionary*)dictionaryFromTranslatedItem:(TranslatedItem*)item
{
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	
	dic[@"sourceLanguage"] = item.sourceLanguage ? item.sourceLanguage : @"";
	dic[@"sourceText"] = item.sourceText ? item.sourceText : @"";
	dic[@"targetLanguage"] = item.targetLanguage ? item.targetLanguage : @"";
	dic[@"targetText"] = item.targetText ? item.targetText : @"";
	
	return dic;
}

- (void)requestManager:(id)arg1 didFinishTranslation:(TranslatedItem*)arg2 error:(NSError*)arg3
{
	TranslateAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	appDelegate.translateViewController.translationManager.delegate = appDelegate.translateViewController;
	
	if(!arg3) {
		NSDictionary *info = @{@"destination": latestRequestApp.copy, @"json": [self dictionaryFromTranslatedItem:arg2]};
		
		[objc_getClass("TTTIPC") sendMessageToSpringBoardWithMessageName:@"TTT.ReceiveTranslation" dictionary:info replyHandler:nil];
		
		latestRequestApp = nil;
	}
}

- (void)completedSpeechFileDownload:(NSData*)data
{
	NSDictionary *info = @{@"destination": latestRequestApp.copy, @"mp3": data};
	
	[objc_getClass("TTTIPC") sendMessageToSpringBoardWithMessageName:@"TTT.ReceiveTextToSpeech" dictionary:info replyHandler:nil];
	
	latestRequestApp = nil;
}

@end