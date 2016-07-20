@protocol GTRTranslationRequestManagerDelegate <NSObject>

- (void)requestManager:(id)arg1 didFinishTranslation:(id)arg2 error:(NSError*)arg3;

@end

@interface GTRTranslationRequestManager : NSObject <GTRTranslationRequestDelegate>

@property(nonatomic) __weak id <GTRTranslationRequestManagerDelegate> delegate;

- (void)requestTranslationForText:(id)arg1 sourceLanguageCode:(id)arg2 targetLanguageCode:(id)arg3 deviceLanguageCode:(id)arg4 inputMethod:(int)arg5 OTFState:(unsigned char)arg6;

@end