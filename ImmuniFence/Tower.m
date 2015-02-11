//
//  Tower.m
//  ImmuniFense
//
//  Created by Mayara Coelho on 2/6/15.
//  Copyright (c) 2015 Group 9. All rights reserved.
//

#import "Tower.h"
#import "Creep.h"
#import "BitMasks.h"
#import "Level.h"

// falta ver os sprites das torres.
@implementation Bullet

+(instancetype)bulletOfType:(int)type withColor:(UIColor *)color {
   
    Bullet *bullet;
    bullet = [self spriteNodeWithImageNamed:[NSString stringWithFormat:@"bullet_%d", type]];
    bullet.color = color;
    bullet.colorBlendFactor = 0.8;
    bullet.name = @"bullet";
    bullet.anchorPoint = CGPointMake(0.5, 0.5);
    bullet.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(5, 5)];
    bullet.physicsBody.dynamic = NO;
    bullet.physicsBody.categoryBitMask = BulletMask;
    bullet.physicsBody.contactTestBitMask = CreepMask;
    bullet.physicsBody.collisionBitMask = 0;
    bullet.zPosition = 0;
    return bullet;
}


@end
@implementation Tower

+(instancetype) createTowerOfType:(TowerType)type withLevel:(NSInteger)level{
   
    Tower *tower;
    // O level é o imutável, logo deve ser o primero e o typo é o sprite da tower.
    tower = [self spriteNodeWithImageNamed:[NSString stringWithFormat:@"tower%d_down0", type]];
    //NSLog(@"level %d",level);
    tower.anchorPoint = CGPointMake(0.5, 0.5);
    tower.name = @"tower";
    tower.level = level;
    tower.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:75];
    tower.physicsBody.dynamic = YES;
    tower.physicsBody.affectedByGravity = NO;
    tower.physicsBody.categoryBitMask = TowerMask;
    tower.physicsBody.contactTestBitMask = CreepMask;
    tower.physicsBody.collisionBitMask = 0;
    tower.zPosition = 1;
    tower.xScale = 0.5;
    tower.yScale = 0.5;
    
    tower.targets = [[NSMutableArray alloc] init];
    if (type == TowerOne) {
        tower.damage = 10;
        tower.bulletType = 1;
        tower.fireRate = 3;
        tower.cost = 90;
        tower.type = TowerOne;
        tower.bulletColor = [UIColor blueColor];
    }else if (type == TowerTwo) {
        tower.damage = 20;
        tower.bulletType = 1;
        tower.fireRate = 3;
        tower.cost = 100;
        tower.type = TowerTwo;
        tower.bulletColor = [UIColor blueColor];
    }else if (type == TowerThree) {
        tower.damage = 15;
        tower.bulletType = 1;
        tower.fireRate = 10;
        tower.cost = 110;
        tower.type = TowerThree;
        tower.bulletColor = [UIColor blueColor];
    }else if (type == TowerFour) {
        tower.damage = 20;
        tower.bulletType = 1;
        tower.fireRate = 3;
        tower.cost = 120;
        tower.type = TowerFour;
        tower.bulletColor = [UIColor blueColor];
    }
    
    tower.lastShot = 0;

    return tower;
}

-(void) shootAtTarget {
    
    SKSpriteNode *target;
    
    if (self.targets.count != 0){

        NSLog(@"atira no alvo");

        target = self.targets[0];
        
        float angle = [self getRotationWithPoint:self.position endPoint:target.position];
        
        SKSpriteNode *bullet = [Bullet bulletOfType:_bulletType withColor: _bulletColor];
        bullet.zRotation = angle;
        
        [self addChild:bullet];
        
        
        CGPoint creepPoint = [self convertPoint:target.position fromNode:self.parent];
        
        SKAction *move = [SKAction moveTo:creepPoint duration:0.3];
        
        [bullet runAction:move completion:^{
            [bullet removeFromParent];
        }];
    
    }
    else
        [self removeAllActions];
}

// método que pega o ponto do target para transformar e, radianos
- (float)getRotationWithPoint:(CGPoint)spoint endPoint:(CGPoint)epoint {
    CGPoint originPoint = CGPointMake(epoint.x - spoint.x, epoint.y - spoint.y); // get origin point to origin by subtracting end from start
    float bearingRadians = atan2f(originPoint.y, originPoint.x); // get bearing in radians
    return bearingRadians;
    
}
@end