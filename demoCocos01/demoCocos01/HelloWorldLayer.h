//
//  HelloWorldLayer.h
//  demoCocos01
//
//  Created by huande on 12-8-30.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import "cocos2d.h"

@interface HelloWorldLayer : CCLayer
{
	CGPoint prePoint;
	NSInteger countCleared;
	NSMutableArray *arrayMap;
	NSInteger counter;
}

+(CCScene *) scene;

@end


@interface MapNode : NSObject

@property (readwrite, nonatomic) NSInteger order;
@property (readwrite, nonatomic) NSInteger imgid;

@end
