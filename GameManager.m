#import "GameManager.h"
#import "SimpleAudioEngine.h"

static GameManager *sharedInstance = nil;


@implementation GameManager

@synthesize soundsEnabled,languageString,language,instructionsLanguage, fxVolume, musicVolume,onPause,instructionsLanguageString;
@synthesize playedMenuVideo;

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
		
		[self setLanguage:1];
		[self setInstructionsLanguage:1];
		[self setMusicVolume:1];
		[self setFxVolume:1];
		
		return self;
	}
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
	switch (vol) {
		case 0:
			[[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.1];
			break;
		case 1:
			[[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.3];
			break;
		case 2:
			[[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:1];
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
