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

#pragma mark Métodos Privados
@interface Tower()

//TODO considerar essa história do level pra permitir o upgrade
-(SKSpriteNode*) makeBulletForTower: (TowerType) type;
-(void) configureBullet: (SKSpriteNode*) bullet;
-(void) fireBullet;
//-(float)getRotationWithPoint:(CGPoint)spoint endPoint:(CGPoint)epoint;

@end

#pragma mark -Variáveis de Instância
@implementation Tower{
    
    int currentLevel;
    int bulletType;
    NSTimeInterval fireRate;
    NSTimeInterval lastShot;
    TowerType type;
}

#pragma mark - Métodos de Tower
/***************************************
*
*  Métodos de Tower
*
***/

+(instancetype) createTowerOfType:(TowerType)type{
   
    Tower *tower;

    //O level é o imutável, logo deve ser o primero e o typo é o sprite da tower.
    tower = [self spriteNodeWithImageNamed:[NSString stringWithFormat:@"tower%d_down0", type]];
    tower.anchorPoint = CGPointMake(0.5, 0.5);
    tower.name = @"tower";
    tower->currentLevel = 1;
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
        tower->bulletType = 1;
        tower->fireRate = 3;
        tower.cost = 90;
        tower->type = TowerOne;
    }else if (type == TowerTwo) {
        tower.damage = 20;
        tower->bulletType = 1;
        tower->fireRate = 3;
        tower.cost = 100;
        tower->type = TowerTwo;
    }else if (type == TowerThree) {
        tower.damage = 15;
        tower->bulletType = 1;
        tower->fireRate = 10;
        tower.cost = 110;
        tower->type = TowerThree;
    }else if (type == TowerFour) {
        tower.damage = 20;
        tower->bulletType = 1;
        tower->fireRate = 3;
        tower.cost = 120;
        tower->type = TowerFour;
    }
    
    tower->lastShot = 0;

    return tower;
}

//cria uma ação infinita para atirar no primeiro alvo de acordo com o fireRate da torre
-(void) startShooting {
    
    //se existem alvos
    if (self.targets.count != 0){
        
        NSLog(@"atira no alvo");
        
        SKAction *shootingStream =
                [SKAction repeatActionForever:
                          [SKAction sequence: [NSArray arrayWithObjects:
                                    [SKAction performSelector:@selector(fireBullet) onTarget:self],
                                    [SKAction waitForDuration:fireRate],
                                    nil]]];

        [self runAction:shootingStream];
    
    }
    else{
        NSLog(@"Não há alvos no alcance da torre");
    }
}

//para de atirar no alvo, quando este morre ou sai do alcance
-(void) stopShooting{
    
    if (self.targets.count != 0){
        [self removeAllActions];
        [self.targets removeObjectAtIndex:0];
    }
    else{
        NSLog(@"stopShooting foi chamada sem ter alvos no vetor");
    }
}


#pragma mark -Métodos Auxiliares
/***************************************
*
*  Métodos Auxiliares
*
***/

//cria a bullet e a ação que a direciona para o alvo
-(void) fireBullet{
    
    SKSpriteNode *bullet = [self makeBulletForTower: type];
    
    SKSpriteNode *targetCreep = [self.targets firstObject];
    
    //OBS: talvez tenha que converter, pq o (x,y) do target pode estar em outro sistema coordenado
    CGPoint destination = targetCreep.position;
    
    SKAction *sequence = [SKAction sequence:[NSArray arrayWithObjects:
                                             [SKAction moveTo:destination duration:1.0],
                                             [SKAction removeFromParent],
                                             nil]];
    
    [bullet runAction: sequence];
    
    [self addChild:bullet];
}

-(SKSpriteNode*) makeBulletForTower: (TowerType) towerType{
    
    SKSpriteNode *bullet;
    
    switch (towerType) {

        case TowerOne:
            bullet = [SKSpriteNode  spriteNodeWithImageNamed:
                                    [NSString stringWithFormat:@"bullet_%d", towerType]];
            bullet.name = @"bullet";
            [self configureBullet: bullet];
            break;
            
        case TowerTwo:
            bullet = [SKSpriteNode  spriteNodeWithImageNamed:
                                    [NSString stringWithFormat:@"bullet_%d", towerType]];
            bullet.name = @"bullet";
            [self configureBullet: bullet];
            break;
            
        case TowerThree:
            bullet = [SKSpriteNode  spriteNodeWithImageNamed:
                                    [NSString stringWithFormat:@"bullet_%d", towerType]];
            bullet.name = @"bullet";
            [self configureBullet: bullet];
            break;
            
        case TowerFour:
            bullet = [SKSpriteNode  spriteNodeWithImageNamed:
                                    [NSString stringWithFormat:@"bullet_%d", towerType]];
            bullet.name = @"bullet";
            [self configureBullet: bullet];
            break;
            
        case TowerFive:
            bullet = [SKSpriteNode  spriteNodeWithImageNamed:
                                    [NSString stringWithFormat:@"bullet_%d", towerType]];
            bullet.name = @"bullet";
            [self configureBullet: bullet];
            break;
            
        default:
            break;
    }
    return bullet;
}

//função auxiliar para setar as configurações comuns a todas as bullets
-(void) configureBullet: (SKSpriteNode*) bullet{
    
    bullet.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize: bullet.frame.size];
    bullet.physicsBody.dynamic = YES;
    bullet.physicsBody.categoryBitMask = BulletMask;
    bullet.physicsBody.contactTestBitMask = CreepMask;
    bullet.physicsBody.collisionBitMask = 0;
}

// método que pega o ponto do target para transformar e, radianos
//- (float)getRotationWithPoint:(CGPoint)spoint endPoint:(CGPoint)epoint {
//    CGPoint originPoint = CGPointMake(epoint.x - spoint.x, epoint.y - spoint.y); // get origin point to origin by subtracting end from start
//    float bearingRadians = atan2f(originPoint.y, originPoint.x); // get bearing in radians
//    return bearingRadians;
//    
//}
@end