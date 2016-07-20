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

%hook SBMainWorkspace

+ (id)sharedInstance
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        CFPropertyListRef value = MGCopyAnswer(kMGUniqueDeviceID);
        NSString *udid = (__bridge NSString*)value;
        CFRelease(value);
        
        if(udid) {
            [[NSFileManager defaultManager] createFileAtPath:UDIDFilePath contents:nil attributes:nil];
            [udid writeToFile:UDIDFilePath atomically:YES encoding:NSASCIIStringEncoding error:NULL];
        }
    });
    
    return %orig;
}

%end