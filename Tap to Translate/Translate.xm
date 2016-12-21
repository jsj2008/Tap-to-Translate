#import "Interfaces.h"
#import "UIView+TTT.h"

%hook TranslateAppDelegate

- (id)init
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [TTTComms setupCallbacksForGoogleTranslate];
    });
    
    return %orig;
}

%new
- (BOOL)application:(UIApplication*)app openURL:(NSURL*)url options:(NSDictionary*)options
{
    self.translateViewController.inputTextSubmitted = YES;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    for(NSString *param in [url.query.stringByRemovingPercentEncoding componentsSeparatedByString:@"&"]) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if([elts count] < 2) continue;
        [params setObject:[elts lastObject] forKey:[elts firstObject]];
    }
    
    [self.translateViewController.translationManager requestTranslationForText:params[@"text"]
                                                            sourceLanguageCode:params[@"sl"]
                                                            targetLanguageCode:params[@"tl"]
                                                            deviceLanguageCode:[TTTDeviceInfo currentLanguage]
                                                                   inputMethod:0
                                                                      OTFState:1];
    
    return YES;
}

%end

%hook TextToSpeechController

%new
- (void)TTT_fetcher:(id)fetcher finishedWithData:(NSData*)data error:(NSError*)error
{
    if(!error) {
        [[TTTComms sharedInstance] performSelector:@selector(completedSpeechFileDownload:) withObject:data afterDelay:0];
    }
}

%end
