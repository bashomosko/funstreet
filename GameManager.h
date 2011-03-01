
@class ChangeableLayer;

@interface GameManager : NSObject {
	
	BOOL soundsEnabled;
}

@property (nonatomic,readwrite) BOOL soundsEnabled;

+ (GameManager *)sharedGameManager;



@end