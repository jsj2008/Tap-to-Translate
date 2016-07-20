//
//  headers.h
//  
//
//  Created by Mohamed Marbouh on 2016-05-24.
//
//

#ifndef headers_h
#define headers_h

#define UDIDFilePath @"/Library/Application Support/Tap to Translate/UDID.txt"

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

#import "UIKit.h"

#import "../libobjcipc/objcipc.h"

#import "libMobileGestalt.h"

#import "GTRTranslationRequest.h"
#import "GTRTranslationRequestManager.h"

#import "LanguageInfo.h"
#import "LanguageSelectionViewController.h"

#import "TextToSpeechController.h"
#import "TranslateAppDelegate.h"
#import "TranslatedItem.h"
#import "TranslateViewController.h"

#import "../TapToTranslate.h"

#import "../TTTAssets.h"
#import "../TTTAudioButton.h"
#import "../TTTBubble.h"
#import "../TTTComms.h"
#import "../TTTContentSeparatorView.h"
#import "../TTTCopyingOptionsDataSource.h"
#import "../TTTCopyingOptionsDelegate.h"
#import "../TTTDeviceInfo.h"
#import "../TTTGoogleLogoHeaderview.h"
#import "../TTTGoogleStyleButton.h"
#import "../TTTGoogleStyleSelectionView.h"
#import "../TTTLanguageNameContentView.h"
#import "../TTTLanguageSelectionDataSource.h"
#import "../TTTLanguageSelectionDelegate.h"
#import "../TTTLocalizations.h"
#import "../TTTPrefs.h"
#import "../TTTResultsView.h"
#import "../TTTResultTextContentView.h"
#import "../TTTSourceTextContentView.h"

#ifdef __cplusplus
extern "C" {
#endif
	extern void checkForPayment(void(^completed)(BOOL));
	extern NSString *udid();
	extern BOOL isInternetAvailable();
#ifdef __cplusplus
}
#endif

#endif /* headers_h */
