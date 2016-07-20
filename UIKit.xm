#import "headers/headers.h"

static void addTranslationBubble(NSString *text)
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    dispatch_async(dispatch_get_main_queue(), ^{
		[TTTComms requestTranslationForText:text completion:^(NSDictionary *result) {
			[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
			[[UIApplication sharedApplication].keyWindow addSubview:[TTTBubble sharedInstance]];
			
			[[TTTBubble sharedInstance] positionAccordingToWindow];
			[[TTTBubble sharedInstance] configureForEvents];
			[[TTTBubble sharedInstance] configureForTranslation:result];
		}];
    });
}

static void addErrorBubble()
{
    [[UIApplication sharedApplication].keyWindow addSubview:[TTTBubble sharedInstance]];
    
    [[TTTBubble sharedInstance] positionAccordingToWindow];
    [[TTTBubble sharedInstance] configureForEvents];
    [[TTTBubble sharedInstance] configureForNoNetworkError];
}

%hook UIApplication

- (id)init
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [TTTComms setupCallbacksForCurrentApplication];
    });
    
    return %orig;
}

%end

%hook UIPasteboard

- (void)setItems:(NSArray*)items
{
    %log;
    %orig;
    
    if([TapToTranslate hooksEnabled]) {
        NSLog(@"TTT.HooksEnabled");
        
        if([TTTComms isInternetAvailable]) {
            NSDictionary *dic = (items.count > 0 && [items[0] isKindOfClass:NSDictionary.class]) ? items[0] : nil;
            
            if(dic) {
                id value = nil;
                
                if([dic.allKeys containsObject:@"public.utf8-plain-text"]) {
                    value = dic[@"public.utf8-plain-text"];
                } else if([dic.allKeys containsObject:@"public.text"]) {
                    value = dic[@"public.text"];
                }
                
                if(value) {
                    
                    NSLog(@"got value");
                    if([value isKindOfClass:NSData.class]) {
                        NSString *text = [[NSString alloc] initWithData:value encoding:NSUTF8StringEncoding];
                        NSLog(@"adding bubble 1");
                        addTranslationBubble(text);
                    } else if([value isKindOfClass:NSString.class]) {
                        NSLog(@"adding bubble 2");
                        addTranslationBubble(value);
                    }
                } else {
                    NSLog(@"no value");
                }
            }
        } else {
            NSLog(@"adding error bubble");
            addErrorBubble();
        }
    } else {
        NSLog(@"TTT.HooksDisabled");
    }
}

- (void)setData:(NSData*)data forPasteboardType:(NSString*)type
{
    %log;
    %orig;
    
    if([TapToTranslate hooksEnabled]) {
        NSLog(@"TTT.HooksEnabled");
        
        if([TTTComms isInternetAvailable]) {
            NSLog(@"is plain text");
			if([type isEqualToString:@"public.utf8-plain-text"]) {
				NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"adding bubble");
				addTranslationBubble(text);
			}
        } else {
            NSLog(@"adding error bubble");
            addErrorBubble();
        }
    } else {
        NSLog(@"TTT.HooksDisabled");
    }
}

%end
