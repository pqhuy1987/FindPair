//
//  HelloWorldLayer.m
//  demoCocos01
//
//  Created by huande on 12-8-30.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import "HelloWorldLayer.h"
#import "AppDelegate.h"
#import "SimpleAudioEngine.h"
#import "IntroLayer.h"

#define TAG_START_SPRITE			100
#define TAG_LABEL_CONNER			501
#define TAG_LABEL_NUMBER			502
#define OFFSET_X							-40
#define OFFSET_Y							60
#define SIZE_W								40
#define SIZE_H								40
#define TOTAL_X								10
#define TOTAL_Y								10
#define TOTAL_IMG							16
#define MAX_CLEARED						24

#pragma mark - HelloWorldLayer

@implementation HelloWorldLayer

+ (CCScene *)scene
{
	CCScene *scene = [CCScene node];
	HelloWorldLayer *layer = [HelloWorldLayer node];
	[scene addChild: layer];
	return scene;
}

- (id)init
{
	self = [super init];
	if(self) {
		[self initSound];
		[self initData];
		[self initView];
	}
	return self;
}

- (void) dealloc
{
	[arrayMap release];
	[super dealloc];
}

#pragma mark my own

- (void)initSound
{
	[[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.3f];
	[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"back1.mp3" loop:NO];
	[[CDAudioManager sharedManager] setBackgroundMusicCompletionListener:self selector:@selector(soundFinish1)];
}

- (void)soundFinish1
{
	[[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
	[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"back2.mp3" loop:NO];
	[[CDAudioManager sharedManager] setBackgroundMusicCompletionListener:self selector:@selector(soundFinish2)];
}

- (void)soundFinish2
{
	[[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
	[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"back3.mp3" loop:NO];
	[[CDAudioManager sharedManager] setBackgroundMusicCompletionListener:self selector:@selector(soundFinish1)];
}

- (void)initData
{
	prePoint = CGPointMake(-1, -1);
	countCleared = 0;
	counter = 0;
	NSMutableArray *array = [[NSMutableArray alloc] init];
	srandom((unsigned int)time(nil));
	for (int i = 0; i < (TOTAL_X - 2) * (TOTAL_Y - 2); ++i) {
		MapNode *mapnode = [[MapNode alloc] init];
		mapnode.order = (int)(CCRANDOM_0_1() * NSIntegerMax) % (int)(CCRANDOM_0_1() * NSIntegerMax);
		mapnode.imgid = imgMap[i];
		[array addObject:mapnode];
	}
	NSArray *sortarray = [array sortedArrayUsingSelector:@selector(myCompare:)];;
	arrayMap = [[NSMutableArray alloc] init];
	
	for (int x = 0; x < TOTAL_X; ++x) {
		for (int y = 0; y < TOTAL_Y; ++y) {
			if (x == 0 || x == (TOTAL_X - 1) || y == 0 || (y == TOTAL_Y - 1)) {
				MapNode *mapnode = [[MapNode alloc] init];
				mapnode.order = 0;
				mapnode.imgid = 0;
				[arrayMap addObject:mapnode];
			} else {
				int i = (y - 1) * (TOTAL_Y - 2) + x - 1;
				[arrayMap addObject:[sortarray objectAtIndex:i]];
			}
		}
	}
}

- (void)initView
{
	self.isTouchEnabled = YES;
	CGSize size = [[CCDirector sharedDirector] winSize];
	CCSprite *background;
	background = [CCSprite spriteWithFile:@"bg.png"];
	background.position = ccp(size.width/2, size.height/2);
	[self addChild: background];
	for (int y = 0; y < TOTAL_Y; ++y) {
		for (int x = 0; x < TOTAL_X; ++x) {
			NSInteger index = y * TOTAL_Y + x;
			if ([self imageFilename:index]) {
				CCSprite *sprite = [CCSprite spriteWithFile:[self imageFilename:index]];
                sprite.scale=0.5;
				sprite.position = ccp(OFFSET_X + (SIZE_W / 2) + SIZE_W * x, OFFSET_Y + (SIZE_H / 2) + SIZE_H * y);
				[self addChild:sprite z:0 tag:(TAG_START_SPRITE + index)];
			}
		}
	}
	
	CCSprite *button;
	button = [CCSprite spriteWithFile:@"play.png"];
	button.position = ccp(size.width - 55, 25);
	[self addChild:button];
	
	CCLabelTTF *label = [CCLabelTTF labelWithString:@"进度:0%" fontName:@"Arial" fontSize:20];
	label.position = ccp(50, 15);
	[self addChild:label z:0 tag:TAG_LABEL_CONNER];
	
	CCLabelTTF *labelnum1 = [CCLabelTTF labelWithString:@"1" fontName:@"Marker Felt" fontSize:64];
	labelnum1.position =  ccp( size.width /2 , size.height/2 );
	[self addChild: labelnum1];
	
	CCLabelTTF *labelnum2 = [CCLabelTTF labelWithString:@"2" fontName:@"Marker Felt" fontSize:64];
	labelnum2.position =  ccp( size.width /2 , size.height/2 );
	labelnum2.visible = NO;
	[self addChild: labelnum2];
	
	CCLabelTTF *labelnum3 = [CCLabelTTF labelWithString:@"3" fontName:@"Marker Felt" fontSize:64];
	labelnum3.position =  ccp( size.width /2 , size.height/2 );
	labelnum3.visible = NO;
	[self addChild: labelnum3];
	
	CCLabelTTF *labelnum4 = [CCLabelTTF labelWithString:@"GO" fontName:@"Marker Felt" fontSize:64];
	labelnum4.position =  ccp( size.width /2 , size.height/2 );
	labelnum4.visible = NO;
	[self addChild: labelnum4];
	
	id ac  = [labelnum1 runAction:[CCShow action]];
	id ac0 = [labelnum1 runAction:[CCScaleBy actionWithDuration:0.5 scale:2]];
	id ac1 = [labelnum1 runAction:[CCHide action]];
	id ac2 = [labelnum2 runAction:[CCShow action]];
	id ac3 = [labelnum2 runAction:[CCScaleBy actionWithDuration:0.5 scale:2]];
	id ac4 = [labelnum2 runAction:[CCHide action]];
	id ac5 = [labelnum3 runAction:[CCShow action]];
	id ac6 = [labelnum3 runAction:[CCScaleBy actionWithDuration:0.5 scale:2]];
	id ac7 = [labelnum3 runAction:[CCHide action]];
	id ac8 = [labelnum4 runAction:[CCShow action]];
	id ac9 = [labelnum4 runAction:[CCScaleBy actionWithDuration:0.5 scale:2]];
	id ac10= [labelnum4 runAction:[CCHide action]];
	[labelnum1 runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.5], ac , ac0, ac1, nil]];
	[labelnum2 runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.0], ac2, ac3, ac4, nil]];
	[labelnum3 runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.5], ac5, ac6, ac7, nil]];
	[labelnum4 runAction:[CCSequence actions:[CCDelayTime actionWithDuration:2.0], ac8, ac9, ac10, nil]];
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	
	CGPoint ptouch = [touch locationInView:touch.view];
	if (ptouch.x > 250 && ptouch.y > 420) {
		[[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
		[self scheduleOnce:@selector(makeTransition:) delay:0];
	}
	
	CGPoint pointcurrent = [self pointOfView:[touch locationInView:touch.view]];
	
	if ([self isValiableNode:pointcurrent] == NO) {
		return;
	}
	
	if ([self isEmptyNode:pointcurrent]) {
		return;
	}
	
	[[SimpleAudioEngine sharedEngine] playEffect:@"choose.wav"];
	
	if ([self isSamePoints:pointcurrent other:prePoint]) {
		return;
	}
	
	CCSprite *spritecurrent = (CCSprite *)[self getChildByTag:(TAG_START_SPRITE + [self indexFromPoint:pointcurrent])];
	spritecurrent.scale = 0.6;
	
	if ([self isValiableNode:prePoint]) {
		CCSprite *spritepre = (CCSprite *)[self getChildByTag:(TAG_START_SPRITE + [self indexFromPoint:prePoint])];
		if ([self canClearTwo:prePoint Current:pointcurrent]) {
			[[SimpleAudioEngine sharedEngine] playEffect:@"disappear1.wav"];
			[self clearNode:prePoint];
			[self clearNode:pointcurrent];
			spritepre.visible = NO;
			spritecurrent.visible = NO;
			if (++countCleared >= MAX_CLEARED) {
				[[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
				[[SimpleAudioEngine sharedEngine] playEffect:@"win.mp3"];
				[self showWin];
			}
			CCLabelTTF *label = (CCLabelTTF *)[self getChildByTag:TAG_LABEL_CONNER];
			label.string = [NSString stringWithFormat:@"进度:%d%%", (int)(countCleared * 100 / MAX_CLEARED)];
		} else {
			spritepre.scale = 0.5;
		}
	}
	
	prePoint = pointcurrent;
}

#pragma mark util method

- (void)showWin
{
	CCLabelTTF *label = [CCLabelTTF labelWithString:@"恭喜过关！" fontName:@"Arial" fontSize:36];
	CGSize s = [[CCDirector sharedDirector] winSize];
	label.position = ccp(s.width/2, s.height/2);
	[self addChild:label];
	[self scheduleOnce:@selector(makeTransition:) delay:2.0];
}

-(void) makeTransition:(ccTime)dt
{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[IntroLayer scene] withColor:ccWHITE]];
}

- (void)clearNode:(CGPoint)point
{
	int index = [self indexFromPoint:point];
	MapNode *mapnode = [arrayMap objectAtIndex:index];
	mapnode.imgid = 0;
}

- (BOOL)isSamePoints:(CGPoint)p1 other:(CGPoint)p2
{
	return (p1.x == p2.x && p1.y == p2.y);
}

- (BOOL)isValiableNode:(CGPoint)point
{
	return point.x >= 0 && point.x < TOTAL_X && point.y >= 0 && point.y < TOTAL_Y;
}

- (BOOL)isEmptyNode:(CGPoint)point
{
	int index = [self indexFromPoint:point];
	MapNode *mapnode = [arrayMap objectAtIndex:index];
	return (mapnode.imgid == 0);
}

- (BOOL)canClearTwo:(CGPoint)pointpre Current:(CGPoint)pointcurrent
{
	BOOL bMatch = NO;
	int pre = [self indexFromPoint:pointpre];
	int current = [self indexFromPoint:pointcurrent];
	int p = [[arrayMap objectAtIndex:pre] imgid];
	int c = [[arrayMap objectAtIndex:current] imgid];
	
	if (p == c && [self match:pointcurrent other:pointpre]) {
		bMatch = YES;
	}
	
	return bMatch;
}

static int imgMap[64] = {
  1 , 1 , 2 , 2 , 3 , 3 , 4 , 4 ,
  5 , 5 , 5 , 5 , 6 , 6 , 0 , 0 ,
  7 , 7 , 7 , 7 , 8 , 8 , 0 , 0 ,
  9 , 9 , 9 , 9 , 10, 10, 10, 10,
  11, 11, 11, 11, 12, 12, 12, 12,
  13, 13, 13, 13, 14, 14, 14, 14,
	15, 15, 16, 16, 0 , 0 , 0 , 0 ,
  0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ,
};

- (NSString *)imageFilename:(NSInteger)index
{
	int n = [[arrayMap objectAtIndex:index] imgid];
	if (n >= 1 && n <= TOTAL_IMG)
		return [NSString stringWithFormat:@"%d.png", n];
	else
		return nil;
}

- (CGPoint)pointOfView:(CGPoint)point
{
	int x = -1;
	int y = -1;
	if (point.x > OFFSET_X && point.x < TOTAL_X * SIZE_W + OFFSET_X)
		x = (point.x - OFFSET_X) / SIZE_W;
	if (point.y > 480 - OFFSET_Y - TOTAL_Y * SIZE_H && point.y < 480 - OFFSET_Y)
		y = (480 - point.y - OFFSET_Y) / SIZE_H;
	return CGPointMake(x, y);
}

- (NSInteger)indexFromPoint:(CGPoint)point
{
	return point.y * TOTAL_Y + point.x;
}

#pragma mark link

- (BOOL)match_direct:(CGPoint)a other:(CGPoint)b
{
	if (!(a.x == b.x || a.y == b.y)) {
		return NO;
	}
	
	int i;
	BOOL match_x = NO;
	if(a.x == b.x) {
		match_x = YES;
		if(a.y > b.y) {
			for(i = a.y - 1; i > b.y; --i) {
				CGPoint point = CGPointMake(a.x, i);
				if(![self isValiableNode:point] ||
					 ![self isEmptyNode:point]) {
					match_x = NO;
				}
			}
		}
		if(b.y > a.y) {
			for(i = b.y - 1; i > a.y; --i) {
				CGPoint point = CGPointMake(a.x, i);
				if(![self isValiableNode:point] ||
					 ![self isEmptyNode:point]) {
					match_x = NO;
				}
			}
		}
	}
	
	BOOL match_y = NO;
	if(a.y == b.y) {
		match_y = YES;
		if(a.x > b.x) {
			for(i = a.x - 1; i > b.x; --i) {
				CGPoint point = CGPointMake(i, a.y);
				if(![self isValiableNode:point] ||
					 ![self isEmptyNode:point]) {
					match_y = NO;
				}
			}
		}
		if(b.x > a.x) {
			for(i = b.x - 1; i > a.x; --i) {
				CGPoint point = CGPointMake(i, a.y);
				if(![self isValiableNode:point] ||
					 ![self isEmptyNode:point]) {
					match_y = NO;
				}
			}
		}
	}
	
	return match_x || match_y;
}

- (BOOL)match_one_corner:(CGPoint)a other:(CGPoint)b
{
	CGPoint point = CGPointMake(b.x, a.y);
	if([self isValiableNode:point] &&
		 [self isEmptyNode:point] &&
		 [self match_direct:a other:point] &&
		 [self match_direct:b other:point]) {
		return YES;
	}
	
	point = CGPointMake(a.x, b.y);
	if([self isValiableNode:point] &&
		 [self isEmptyNode:point] &&
		 [self match_direct:a other:point] &&
		 [self match_direct:b other:point]) {
		return YES;
	}
	
	return NO;
}

- (BOOL)match_two_corner:(CGPoint)a other:(CGPoint)b
{
	for(int i = a.x - 1; i >= 0; --i) {
		CGPoint point = CGPointMake(i, a.y);
		if(![self isValiableNode:point] || ![self isEmptyNode:point]) {
			break;
		} else {
			if([self match_one_corner:point other:b]) {
				return YES;
			}
		}
	}
	
	for(int i = a.x + 1; i < TOTAL_X; ++i) {
		CGPoint point = CGPointMake(i, a.y);
		if(![self isValiableNode:point] || ![self isEmptyNode:point]) {
			break;
		} else {
			if([self match_one_corner:point other:b]) {
				return YES;
			}
		}
	}
	
	for(int i = a.y - 1; i >= 0; --i) {
		CGPoint point = CGPointMake(a.x ,i);
		if(![self isValiableNode:point] || ![self isEmptyNode:point]) {
			break;
		} else {
			if([self match_one_corner:point other:b]) {
				return YES;
			}
		}
	}
	
	for(int i = a.y + 1; i < TOTAL_Y; ++i) {
		CGPoint point = CGPointMake(a.x ,i);
		if(![self isValiableNode:point] || ![self isEmptyNode:point]) {
			break;
		} else {
			if([self match_one_corner:point other:b]) {
				return YES;
			}
		}
	}
	
	return NO;
}

- (BOOL)match:(CGPoint)a other:(CGPoint)b
{
	if([self match_direct:a other:b]) {
		return YES;
	}
	
	if([self match_one_corner:a other:b]) {
		return YES;
	}
	
	if([self match_two_corner:a other:b]) {
		return YES;
	}
	
	return NO;
}

@end

@implementation MapNode

- (NSComparisonResult) myCompare:(MapNode *)other {
	if (self.order > other.order) {
		return 1;
	} else if (self.order == other.order) {
		return 0;
	} else {
		return -1;
	}
}

@end
