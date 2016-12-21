@interface TranslateViewController : UIViewController <GTRTranslationRequestManagerDelegate>

@property(nonatomic) BOOL inputTextSubmitted;
@property(retain, nonatomic) LanguageSelectionViewController *languageSelectionViewController;
@property(retain, nonatomic) GTRTranslationRequestManager *translationManager;

@end