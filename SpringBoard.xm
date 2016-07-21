#import "headers/headers.h"

%hook SpringBoard

- (id)init
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [TTTComms setupCallbacksForSpringBoard];
    });
    
    return %orig;
}

%end