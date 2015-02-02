//
//  Level1.m
//  ImmuniFense
//
//  Created by Victor Yves Crispim on 02/5/15.
//  Copyright (c) 2015 Group 9. All rights reserved.
//

#import "Level1.h"
//#import "Wave.h"
//#import "Terrain.h"
//#import "Creep.h"
//#import "Tower.h"


@implementation Level1{
    
    int coins;
    int health;
    int killCount;
    int waveNumber;
    
}

-(id)initWithSize:(CGSize)size{

    coins = 90;
    health = 20;
    killCount = 0;
    waveNumber = 0;
    
    
    return self;
}

-(void) update:(NSTimeInterval)currentTime{
}


-(void) didBeginContact:(SKPhysicsContact *)contact{
    
}

-(void) didEndContact:(SKPhysicsContact *)contact{
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
}

-(void)selectNodeForTouch:(CGPoint)touchLocation{
    
}

@end
