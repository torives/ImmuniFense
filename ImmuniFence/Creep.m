//
//  Creep.m
//  ImmuniFense
//
//  Created by Victor Yves Crispim on 02/5/15.
//  Copyright (c) 2015 Group 9. All rights reserved.
//

#import "BitMasks.h"
#import "Creep.h"

@interface Creep ()

+(void)initAnimationTextures: (Creep *) creep;
-(void) animateLeft;
-(void) animateRight;
-(void) animateUp;
-(void) animateDown;

@end


@implementation Creep{
    
    NSMutableArray *creepUpTextures;
    NSMutableArray *creepDownTextures;
    NSMutableArray *creepLeftTextures;
}

/***************************************
*
*  Métodos Próprios
*
***/

+(instancetype) creepOfType:(CreepType)type {
    
    Creep *creep = [self spriteNodeWithImageNamed: [NSString stringWithFormat:
                                                    @"creep%d_left0", type]];
    
    //TODO carregar isso de um arquivo
    creep.damage = 1;
    creep.hitPoints = 80;
    creep.reward = 10;
    creep.velocity = 10;
    creep.direction = ' ';
    creep.lastPosition = CGPointMake(9999, 9999);
    
    if (type == CreepOne) {
        
        creep.type = CreepOne;
    }
    else if (type == CreepTwo) {
        
        creep.type = CreepTwo;
    }
    else{
        
    }
    
    creep.name = @"creep";
    creep.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:creep.frame.size];
    creep.physicsBody.dynamic = YES;
    creep.physicsBody.affectedByGravity = NO;
    creep.physicsBody.categoryBitMask = CreepMask;
    creep.physicsBody.contactTestBitMask = TowerMask;
    creep.physicsBody.collisionBitMask = 0;
    
    [self initAnimationTextures: creep];
    
    return creep;
}

-(void) updateAnimation{
    
    if (self.position.x < self.lastPosition.x && self.direction != 'l') {
        [self animateLeft];
        self.direction = 'l';
        self.lastPosition = self.position;
    }
    
    else if (self.position.x > self.lastPosition.x && self.direction != 'r'){
        [self animateRight];
        self.direction = 'r';
        self.lastPosition = self.position;
    }
    
    if (self.position.y < self.lastPosition.y && self.direction != 'd') {
        [self animateDown];
        self.direction = 'd';
        self.lastPosition = self.position;
    }
    
    else if (self.position.y > self.lastPosition.y && self.direction != 'u'){
        [self animateUp];
        self.direction = 'u';
        self.lastPosition = self.position;
    }
}

/***************************************
*
*  Métodos Privados
*
***/

-(void) animateLeft{
    
    SKAction *walkLeft = [SKAction animateWithTextures:creepLeftTextures
                                          timePerFrame:0.05];
    SKAction *repeatLeft = [SKAction repeatActionForever:walkLeft];
    [self runAction:repeatLeft];
}

//Usa as texturas da esquerda e inverte o x do sprite
-(void) animateRight{
    
    SKAction *walkRight = [SKAction animateWithTextures:creepLeftTextures
                                           timePerFrame:0.05];
    SKAction *repeatRight = [SKAction repeatActionForever:walkRight];
    
    self.xScale = fabs(self.xScale) * -1;
    [self runAction:repeatRight];
}

-(void) animateUp{
    
    SKAction *walkUp = [SKAction animateWithTextures:creepUpTextures
                                        timePerFrame:0.05];
    SKAction *repeatUp = [SKAction repeatActionForever:walkUp];
    [self runAction:repeatUp];
}

-(void) animateDown{
    
    SKAction *walkDown = [SKAction animateWithTextures:creepDownTextures
                                          timePerFrame:0.05];
    SKAction *repeatDown = [SKAction repeatActionForever:walkDown];
    [self runAction:repeatDown];
}

//inicializa os 4 vetores de texturas do creep
+(void)initAnimationTextures: (Creep *) creep{
    
    NSString *baseNameLeft;
    NSString *baseNameDown;
    NSString *baseNameUp;
    NSString *baseNameRight;
    SKTextureAtlas *atlas;
    
    //atribui o nome do atlas correto para cada tipo de creep
    if (creep.type == CreepOne){
        
        baseNameLeft = @"creep1_left";
        baseNameDown = @"creep1_down";
        baseNameUp = @"creep1_up";
        baseNameRight = @"creep1_right";
    }
    else if (creep.type == CreepTwo){
        
        baseNameLeft = @"creep2_left";
        baseNameDown = @"creep2_down";
        baseNameUp = @"creep2_up";
        baseNameRight = @"creep2_right";
    }
    
    //inicializa o creepLeftTextures
    atlas = [SKTextureAtlas atlasNamed:baseNameLeft];
    creep->creepLeftTextures = [[NSMutableArray alloc] init];
    
    for (int i=0; i<atlas.textureNames.count; i++){
        
        SKTexture *texture = [atlas textureNamed:
                              [baseNameLeft stringByAppendingString:
                               [NSString stringWithFormat:@"%d.png",i]]];
        [creep->creepLeftTextures addObject: texture];
    }
    
    //inicializa o creepDownTextures
    atlas = [SKTextureAtlas atlasNamed:baseNameDown];
    creep->creepDownTextures = [[NSMutableArray alloc] init];
    
    for (int i=0; i<atlas.textureNames.count; i++){
        
        SKTexture *texture = [atlas textureNamed:
                              [baseNameDown stringByAppendingString:
                               [NSString stringWithFormat:@"%d.png",i]]];
        [creep->creepDownTextures addObject: texture];
    }
    
    //inicializa o creepUpTextures
    atlas = [SKTextureAtlas atlasNamed:baseNameUp];
    creep->creepUpTextures = [[NSMutableArray alloc] init];
    
    for (int i=0; i<atlas.textureNames.count; i++){
        
        SKTexture *texture = [atlas textureNamed:
                              [baseNameUp stringByAppendingString:
                               [NSString stringWithFormat:@"%d.png",i]]];
        [creep->creepUpTextures addObject: texture];
    }
    
}

@end