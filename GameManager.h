
@class ChangeableLayer;

@interface GameManager : NSObject {
	
	BOOL soundsEnabled;
	int language;
	int instructionsLanguage;
	int fxVolume;
	int musicVolume;
	NSMutableString * languageString;
	NSMutableString * instructionsLanguageString;
	BOOL onPause;
	BOOL playedMenuVideo;
}

@property (nonatomic,readwrite) BOOL soundsEnabled;
@property (nonatomic,readwrite) int language;
@property (nonatomic,readwrite) int instructionsLanguage;
@property (nonatomic,readwrite) int fxVolume;
@property (nonatomic,readwrite) int musicVolume;
@property (nonatomic, retain) NSString * languageString;
@property (nonatomic, retain) NSMutableString * instructionsLanguageString;
@property (nonatomic,readwrite) BOOL onPause;
@property (nonatomic,readwrite) BOOL playedMenuVideo;

+ (GameManager *)sharedGameManager;



@end