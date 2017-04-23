//
//  IntroLayer.m
//  demoCocos01
//
//  Created by huande on 12-8-30.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import "IntroLayer.h"
#import "HelloWorldLayer.h"

#pragma mark - IntroLayer

@implementation IntroLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	IntroLayer *layer = [IntroLayer node];
	[scene addChild: layer];
	return scene;
}

-(void) onEnter
{
	[super onEnter];

	CGSize size = [[CCDirector sharedDirector] winSize];

	CCSprite *background;
	background = [CCSprite spriteWithFile:@"bg.png"];	background.position = ccp(size.width/2, size.height/2);
	[self addChild: background];
	
	CCLabelTTF *label = [CCLabelTTF labelWithString:@"连连看" fontName:@"Marker Felt" fontSize:48];
	label.position =  ccp( size.width /2 , size.height/2 );
	[self addChild: label];
	
	CCSprite *button;
	button = [CCSprite spriteWithFile:@"play.png"];
	button.position = ccp(size.width/2, size.height/2 - 80);
	[self addChild:button];
	
	self.isTouchEnabled = YES;
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self scheduleOnce:@selector(makeTransition:) delay:0];
}

-(void) makeTransition:(ccTime)dt
{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[HelloWorldLayer scene] withColor:ccWHITE]];
}

@end
