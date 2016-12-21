#import <Foundation/Foundation.h>

#define LOG_MESSAGE_BODY 0

#ifdef DEBUG
	#define IPCLOG(x,...) NSLog(@"*** libTTTIPC: %@",[NSString stringWithFormat:(x), ##__VA_ARGS__])
#else
	// Replace with call to [NSString stringWithFormat:] so that any variables passed aren't marked as unused.
	#define IPCLOG(x,...) [NSString stringWithFormat:(x), ##__VA_ARGS__]
#endif

#define PrefPath @"/var/mobile/Library/Preferences/libTTTIPC.plist"
#define XPCObjects "/System/Library/PrivateFrameworks/XPCObjects.framework/XPCObjects"
#define SpringBoardIdentifier @"com.apple.springboard"
#define TTTIPCActivateAppNotification @"TTTIPCActivateAppNotification"
#define TTTIPCDeactivateAppNotification @"TTTIPCDeactivateAppNotification"

@class TTTIPC, TTTIPCConnection, TTTIPCMessage;

typedef NSDictionary *(^TTTIPCIncomingMessageHandler)(NSDictionary *); // return NSDictionary or nil to reply
typedef void(^TTTIPCReplyHandler)(NSDictionary *);

typedef struct {
	
	char magicNumber[3];
	BOOL replyFlag;
	char messageIdentifier[5];
	char messageName[256];
	int contentLength;
	
} TTTIPCMessageHeader;
