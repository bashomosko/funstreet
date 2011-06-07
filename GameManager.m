#import "GameManager.h"
#import "SimpleAudioEngine.h"

static GameManager *sharedInstance = nil;


@implementation GameManager

@synthesize soundsEnabled,languageString,language,instructionsLanguage, fxVolume, musicVolume,onPause,instructionsLanguageString;
@synthesize playedMenuVideo,playedGame1Video,playedGame2Video;

+ (GameManager *)sharedGameManager
{
	@synchronized (self) {
		if (sharedInstance == nil) {
			[[self alloc] init]; // assignment not done here, see allocWithZone
		}
	}
	
	return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;  // assignment and return on first allocation
        }
    }
	
    return nil; //on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;  // This is sooo not zero
}

- (id)init
{
	@synchronized(self) {
		[super init];	
		
		soundsEnabled = YES;
		languageString = [[NSMutableString alloc] initWithCapacity:10];
		instructionsLanguageString = [[NSMutableString alloc] initWithCapacity:10];
		
		NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
		BOOL alreadyPlayed = [[ud objectForKey:@"alreadyPlayed"]boolValue];
		
		if(alreadyPlayed)
		{
			playedMenuVideo = [[ud objectForKey:@"playedMenuVideo"]boolValue];
			playedGame1Video = [[ud objectForKey:@"playedGame1Video"]boolValue];
			playedGame2Video = [[ud objectForKey:@"playedGame2Video"]boolValue];
			[self setLanguage:[[ud objectForKey:@"language"]intValue]];
			[self setInstructionsLanguage:[[ud objectForKey:@"instructionsLanguage"]intValue]];
			[self setMusicVolume:[[ud objectForKey:@"musicVolume"]intValue]];
			[self setFxVolume:[[ud objectForKey:@"fxVolume"]intValue]];
		}else
		{
			[ud setObject:[NSNumber numberWithBool:YES] forKey:@"alreadyPlayed"];
			[self setLanguage:1];
			[self setInstructionsLanguage:0];
			[self setMusicVolume:1];
			[self setFxVolume:1];
			playedMenuVideo = NO;
			playedGame1Video = NO;
			playedGame2Video = NO;
		}
		
		
		return self;
	}
}

-(void)setPlayedMenuVideo:(BOOL)played
{
	playedMenuVideo = played;
	NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
	[ud setObject:[NSNumber numberWithBool:playedMenuVideo] forKey:@"playedMenuVideo"];
}

-(void)setPlayedGame1Video:(BOOL)played
{
	playedGame1Video = played;
	NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
	[ud setObject:[NSNumber numberWithBool:playedGame1Video] forKey:@"playedGame1Video"];
}

-(void)setPlayedGame2Video:(BOOL)played
{
	playedGame2Video = played;
	NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
	[ud setObject:[NSNumber numberWithBool:playedGame2Video] forKey:@"playedGame2Video"];
}

-(void)turnSounds
{
	soundsEnabled = !soundsEnabled;
	if (soundsEnabled) {
		[[SimpleAudioEngine sharedEngine] setMute:NO];
	}else {
		[[SimpleAudioEngine sharedEngine] setMute:YES];
	}

}

-(void)setLanguage:(int)_language
{
	language = _language;
	NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
	[ud setObject:[NSNumber numberWithInt:language] forKey:@"language"];
	switch (language) {
		case 0:
			[languageString setString:@"eng"];
			break;
		case 1:
			[languageString setString:@"esp"];
			break;
	}
}

-(void)setInstructionsLanguage:(int)_language
{
	instructionsLanguage = _language;
	NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
	[ud setObject:[NSNumber numberWithInt:instructionsLanguage] forKey:@"instructionsLanguage"];
	switch (instructionsLanguage) {
		case 0:
			[instructionsLanguageString setString:@"eng"];
			break;
		case 1:
			[instructionsLanguageString setString:@"esp"];
			break;
	}
}

-(void)setFxVolume:(int)vol
{
	fxVolume = vol;
	NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
	[ud setObject:[NSNumber numberWithInt:fxVolume] forKey:@"fxVolume"];
	switch (vol) {
		case 0:
			[[SimpleAudioEngine sharedEngine] setEffectsVolume:0.1];
			break;
		case 1:
			[[SimpleAudioEngine sharedEngine] setEffectsVolume:0.3];
			break;
		case 2:
			[[SimpleAudioEngine sharedEngine] setEffectsVolume:1];
			break;
	}
}

-(void)setMusicVolume:(int)vol
{
	musicVolume = vol;
	NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
	[ud setObject:[NSNumber numberWithInt:musicVolume] forKey:@"musicVolume"];
	switch (vol) {
		case 0:
			[[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.1];
			break;
		case 1:
			[[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.2];
			break;
		case 2:
			[[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:5];
			break;
	}
}

-(void)unlockGame:(int)game
{
}
						  
- (void)dealloc {
	[languageString release];
	[instructionsLanguageString release];
	[super dealloc];
}

@end
