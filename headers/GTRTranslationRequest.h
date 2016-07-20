@class GTRTranslationRequest, TranslatedItem;

@protocol GTRTranslationRequestDelegate <NSObject>

- (void)translationRequest:(GTRTranslationRequest*)arg1 didFinishTranslation:(TranslatedItem*)arg2 error:(NSError*)arg3;

@end

@interface GTRTranslationRequest : NSObject

@property(nonatomic) __weak id <GTRTranslationRequestDelegate> delegate;

- (id)initWithText:(id)arg1 sourceLanguage:(id)arg2 targetLanguage:(id)arg3 deviceLanguage:(id)arg4 inputMethod:(int)arg5 OTFState:(unsigned char)arg6;
- (void)submit;

@end