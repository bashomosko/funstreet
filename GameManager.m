#import "GameManager.h"

static GameManager *sharedInstance = nil;


@implementation GameManager

@synthesize soundsEnabled,languageString,language;

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
		
		[self setLanguage:1];
		
		return self;
	}
}

-(void)turnSounds
{
	soundsEnabled = !soundsEnabled;
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

-(void)unlockGame:(int)game
{
}
						  
- (void)dealloc {
	[languageString release];
	[super dealloc];
}

@end
