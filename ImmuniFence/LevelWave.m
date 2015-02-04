//
//  LevelWave.m
//  ImmuniFense
//
//  Created by Igor Domingues on 2/4/15.
//  Copyright (c) 2015 Group 9. All rights reserved.
//

#import "LevelWave.h"
#import "Creep.h"

@implementation LevelWave
{
    int level; //level corrente - ENUM
}

-(id) init
{
    level = 0;
}

-(id) initWithLevel: (int) lv
{
    level = lv;
}

-(NSMutableArray*) initWithWave:(int) wave
{
    NSMutableArray* creeps = [[NSMutableArray alloc]init];
    //Ler do arquivo com base no level e na wave e criar os creeps correspondentes
    Creep alpha = [[Creep alloc]initWithType:1];
    [creeps addObject:alpha];
    
    
    return creeps;
}

-(NSMutableArray*) initWithWave:(int)wave andCreeps(int)theCreeps
{
    NSMutableArray* creeps = [[NSMutableArray alloc]init];
    //Ler do arquivo com base no level e na wave e criar os creeps correspondentes
    for(;theCreeps<0;theCreeps--)
    {
        Creep alpha = [[Creep alloc]initWithType:1];
        [creeps addObject:alpha];
    }
    
    return creeps;
}
@end
