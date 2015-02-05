//
//  Terrain.h
//  ImmuniFense
//
//  Created by Igor Domingues on 2/3/15.
//  Copyright (c) 2015 Group 9. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface Terrain : NSObject

@property int level;
@property (nonatomic, strong) NSMutableArray *towerSpot;
@property (nonatomic) CGMutablePathRef creeppath;
@property (nonatomic, strong) SKSpriteNode *map;
@property int coins;


-(id) initWithLevel:(int)theLevel andTowerSpot:(NSMutableArray *)theTowerS andPath:(CGMutablePathRef *)thePath andMap:(SKSpriteNode *)theMap andCoins: (int)theCoins;

+(Terrain*) initWithLevel:(int) theLevel;

@end
