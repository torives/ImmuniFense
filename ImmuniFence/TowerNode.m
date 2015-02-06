//
//  TowerNode.m
//  ImmuniFense
//
//  Created by Victor Yves Crispim on 01/5/15.
//  Copyright (c) 2015 Victor Yves Crispim. All rights reserved.
//

#import "TowerNode.h"
#import "Creep.h"
#import "BitMasks.h"
#import "Level.h"

// falta ver os sprites das torres.
@implementation BulletNode

+(instancetype)bulletOfType:(int)type withColor:(UIColor *)color {
    BulletNode *bullet;
    bullet = [self spriteNodeWithImageNamed:[NSString stringWithFormat:@"bullet_%d", type]];
    bullet.color = color;
    //  bullet.colorBlendFactor = 0.8;
    bullet.name = @"bullet";
    bullet.anchorPoint = CGPointMake(0.5, 0.5);
    bullet.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(1, 1)];
    bullet.physicsBody.dynamic = NO;
    bullet.physicsBody.categoryBitMask = BulletMask;
    bullet.physicsBody.contactTestBitMask = CreepMask;
    bullet.physicsBody.collisionBitMask = 0;
    bullet.zPosition = 0;
    return bullet;
}

@end

@implementation TowerNode

+(instancetype) createTowerOfType:(TowerType)type withLevel:(NSInteger)level{
    TowerNode *tower;
    // O level é o imutável, logo deve ser o primero e o typo é o sprite da tower.
    tower = [self spriteNodeWithImageNamed:[NSString stringWithFormat:@"turret-%d-%d",level, type]];
    NSLog(@"level %d",level);
    tower.anchorPoint = CGPointMake(0.5, 0.5);
    tower.name = @"tower";
    tower.level = level;
    tower.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:50];
    tower.physicsBody.dynamic = YES;
    tower.physicsBody.affectedByGravity = NO;
    tower.physicsBody.categoryBitMask = TowerMask;
    tower.physicsBody.contactTestBitMask = CreepMask;
    tower.physicsBody.collisionBitMask = 0;
    tower.zPosition = 1;
    
    tower.targets = [[NSMutableArray alloc] init];
    if (type == TowerOne) {
        tower.damage = 10;
        tower.bulletType = 1;
    }else if (type == TowerTwo) {
        tower.damage = 20;
        tower.bulletType = 1;
    }else if (type == TowerThree) {
        tower.damage = 15;
        tower.bulletType = 1;
    }else if (type == TowerFour) {
        tower.damage = 20;
        tower.bulletType = 1;
    }
    
    // tower's rotate
    //    SKAction *rotationTower = [SKAction sequence:@[[SKAction rotateByAngle: M_1_PI duration:2],
    //                                                   [SKAction rotateByAngle: -M_1_PI duration:2]]];
    //    [tower runAction:[SKAction repeatActionForever:rotationTower]];
    
    return tower;
    // 
}

// método para transformar vetores em radianos.
static inline CGVector *RadiansToVector (CGFloat radians ){
    // criando um vetor
    CGVector vector;
    // transforma a distância de x em radianos
    vector.dx = cosf(radians);
    // transforma a distância de y em radianos
    vector.dy = sinf(radians);
    // retorno do vetor em radianos
    return &vector;
}

static inline float Rotation(CGPoint p)
{
    float arctg = tanhf(p.x/p.y);
    
    if(p.x < 0.0f)
    {
        if(p.y >= 0.0f)
            arctg += M_PI;
        else
            arctg -= M_PI;
    }
    
    return arctg;
}

-(void) shootAtTarget:(SKSpriteNode*)target {
    float angle = [self getRotationWithPoint:self.position endPoint:target.position];
    
    SKSpriteNode *bullet = [BulletNode bulletOfType:_bulletType withColor: self.bullet.color];
    bullet.zRotation = angle;
    [self addChild:bullet];
    CGPoint creepPoint = [self convertPoint:target.position fromNode:self.parent];
    SKAction *move = [SKAction moveTo:creepPoint duration:0.5];
    [bullet runAction:move completion:^{
        [bullet removeFromParent];
    }];
    //
    //    CGPoint direction = target.position;
    //    direction.x -= self.position.x;
    //    direction.y -= self.position.y;
    //
    //    //self.zRotation = angle + M_1_PI/2.0f;
    //    self.zRotation = Rotation(direction) - M_PI/2.0f;
    
    //    SKRange * range = [SKRange rangeWithConstantValue:0.0f];
    //    SKConstraint * constraint = [SKConstraint orientToNode: offset:];
    //
}


// método que trata da vida do enemy
-(void) damageEnemy:(Creep*) enemy onKill:(void (^)()) killHandler {
    enemy.hitPoints = enemy.hitPoints - self.damage;
    if (enemy.hitPoints <= 0) {
        [enemy removeFromParent];
        NSLog(@"Creep killed");
        killHandler();
    }
}

// método que pega o ponto do target para transformar e, radianos
- (float)getRotationWithPoint:(CGPoint)spoint endPoint:(CGPoint)epoint {
    CGPoint originPoint = CGPointMake(epoint.x - spoint.x, epoint.y - spoint.y); // get origin point to origin by subtracting end from start
    float bearingRadians = atan2f(originPoint.y, originPoint.x); // get bearing in radians
    return bearingRadians;
    
}




@end
