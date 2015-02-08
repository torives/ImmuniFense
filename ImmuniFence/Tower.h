//
//  Tower.h
//  ImmuniFense
//
//  Created by Mayara Coelho on 2/6/15.
//  Copyright (c) 2015 Group 9. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <SpriteKit/SpriteKit.h>

// enum dos tipos das torres.
typedef NS_ENUM(NSUInteger, TowerType) {
    TowerOne,
    TowerTwo,
    TowerThree,
    TowerFour,
    TowerFive
};

@interface Tower : SKSpriteNode

+(instancetype) createTowerOfType:(Tower*)type withLevel:(NSInteger)level;

@property (nonatomic, strong) NSMutableArray *targets;
@property (nonatomic) int damage;
@property (nonatomic) int level;
@property (nonatomic) int bulletType;
@property (nonatomic, strong) SKSpriteNode *bullet;
@property (nonatomic, strong) SKSpriteNode *tower;

@property (nonatomic) NSTimeInterval lastShot;

//
@end

@interface Tower ()

// método para atirar nos creeps que ultrapassam o raio da tower.
-(void) shootAtTarget:(SKSpriteNode*)target;
// método para pegar aonde a tower foi criada.
-(float) getRotationWithPoint:(CGPoint)spoint endPoint:(CGPoint)epoint;
// método que causa dano no creep, atira.
-(void) damageEnemy:(SKSpriteNode*) enemy onKill:(void (^)()) killHandler;
@end

@interface Bullet : SKSpriteNode


//método que cria a bala.
+(instancetype) bulletOfType:(int) type withColor:(UIColor*) color;
@end