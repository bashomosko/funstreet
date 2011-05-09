
@class ChangeableLayer;

@interface GameManager : NSObject {
	
	BOOL soundsEnabled;
	int language;
	NSMutableString * languageString;
}

@property (nonatomic,readwrite) BOOL soundsEnabled;
@property (nonatomic,readwrite) int language;
@property (nonatomic, retain) NSString * languageString;

+ (GameManager *)sharedGameManager;



@end