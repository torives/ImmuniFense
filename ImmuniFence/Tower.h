//
//  Tower.h
//  ImmuniFense
//
//  Created by Mayara Coelho on 2/6/15.
//  Copyright (c) 2015 Group 9. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "TowerTypes.h"

@interface Tower : SKSpriteNode

@property (nonatomic) int damage;
@property (nonatomic) int cost;
@property (nonatomic, strong) NSMutableArray *targets;

+(instancetype) createTowerOfType: (TowerType)type;

//começa a atirar nos creeps que estão a alcance
-(void) startShooting;

//para de atirar nos creeps que estão a alcance
-(void) stopShooting;

//-(float) getRotationWithPoint:(CGPoint)spoint endPoint:(CGPoint)epoint;

@end