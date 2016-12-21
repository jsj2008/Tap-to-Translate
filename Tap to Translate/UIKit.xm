#import "Interfaces.h"
#import "UIAlertController+TTT.h"

static void addTranslationBubble(NSString *text)
{
/*	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

	dispatch_async(dispatch_get_main_queue(), ^{
		[TTTComms requestTranslationForText:text completion:^(NSDictionary *result) {
			[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
*/			[[UIApplication sharedApplication].keyWindow addSubview:[TTTBubble sharedInstance]];

			[[TTTBubble sharedInstance] positionAccordingToWindow];
			[[TTTBubble sharedInstance] configureForEvents];
			[[TTTBubble sharedInstance] configureForFirstTime:text];
//		}];
//	});
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
    %orig;

    if([TapToTranslate hooksEnabled]) {
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
                    if([value isKindOfClass:NSData.class]) {
                        NSString *text = [[NSString alloc] initWithData:value encoding:NSUTF8StringEncoding];
                        addTranslationBubble(text);
                    } else if([value isKindOfClass:NSString.class]) {
                        addTranslationBubble(value);
                    }
                }
            }
        } else {
            addErrorBubble();
        }
    }
}

- (void)setData:(NSData*)data forPasteboardType:(NSString*)type
{
    %orig;

    if([TapToTranslate hooksEnabled]) {
        if([TTTComms isInternetAvailable]) {
			if([type isEqualToString:@"public.utf8-plain-text"]) {
				NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
				addTranslationBubble(text);
			}
        }
    }
}

%end
