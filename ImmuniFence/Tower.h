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

// método para atirar nos creeps que entram no raio da tower.
-(void) shootAtTarget;

// método para pegar aonde a tower foi criada.
-(float) getRotationWithPoint:(CGPoint)spoint endPoint:(CGPoint)epoint;