//
//  Creep.h
//  ImmuniFense
//
//  Created by Victor Yves Crispim on 02/5/15.
//  Copyright (c) 2015 Group 9. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM (NSUInteger, CreepType) {
    
    CreepOne = 1,
    CreepTwo = 2,
    CreepThree = 3,
    
};

@interface Creep : SKSpriteNode

@property (nonatomic) int damage;
@property (nonatomic) int hitPoints;
@property (nonatomic) int reward;
@property (nonatomic) NSTimeInterval velocity; //Não implementado
@property (nonatomic) CreepType type;
@property (nonatomic) CGPoint lastPosition;
@property (nonatomic) char direction;

+(instancetype) creepOfType:(CreepType)type;

-(void) updateAnimation;

@end