
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
	BOOL playedGame1Video;
	BOOL playedGame2Video;
    BOOL musicAudioEnabled;
}

@property (nonatomic,readwrite) BOOL soundsEnabled;
@property (nonatomic,readwrite) BOOL musicAudioEnabled;
@property (nonatomic,readwrite) int language;
@property (nonatomic,readwrite) int instructionsLanguage;
@property (nonatomic,readwrite) int fxVolume;
@property (nonatomic,readwrite) int musicVolume;
@property (nonatomic, retain) NSString * languageString;
@property (nonatomic, retain) NSMutableString * instructionsLanguageString;
@property (nonatomic,readwrite) BOOL onPause;
@property (nonatomic,readwrite) BOOL playedMenuVideo;
@property (nonatomic,readwrite) BOOL playedGame1Video;
@property (nonatomic,readwrite) BOOL playedGame2Video;

+ (GameManager *)sharedGameManager;
-(void)turnSounds;
-(void)setLanguage:(int)_language;
-(void)setInstructionsLanguage:(int)_language;
-(void)setFxVolume:(int)vol;
-(void)setMusicVolume:(int)vol;
-(void)setPlayedGame2Video:(BOOL)played;
-(void)setPlayedGame1Video:(BOOL)played;
-(void)setPlayedMenuVideo:(BOOL)played;



@end