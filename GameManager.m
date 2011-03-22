#import "GameManager.h"

static GameManager *sharedInstance = nil;


@implementation GameManager

@synthesize soundsEnabled;

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
		
		
		return self;
	}
}

-(void)turnSounds
{
	soundsEnabled = !soundsEnabled;
}

-(void)unlockGame:(int)game
{
}
						  
- (void)dealloc {
	[super dealloc];
}

@end
