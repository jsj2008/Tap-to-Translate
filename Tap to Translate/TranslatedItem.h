@interface TranslatedItem : NSObject

@property(copy, nonatomic) NSString *sourceLanguage;
@property(copy, nonatomic) NSString *sourceText;
@property(copy, nonatomic) NSString *targetLanguage;
@property(copy, nonatomic) NSString *targetText;


@end