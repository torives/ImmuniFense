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

@property (nonatomic, strong) NSMutableArray *targets;
@property (nonatomic) int damage;
@property (nonatomic) int level;
@property (nonatomic) int bulletType;
@property (nonatomic) int cost;
@property (nonatomic) NSTimeInterval fireRate;
@property (nonatomic) NSTimeInterval lastShot;
@property (nonatomic) TowerType type;

+(instancetype) createTowerOfType: (TowerType)type withLevel:(NSInteger)level;
// método para atirar nos creeps que ultrapassam o raio da tower.
-(void) shootAtTarget;
// método para pegar aonde a tower foi criada.
-(float) getRotationWithPoint:(CGPoint)spoint endPoint:(CGPoint)epoint;

@end