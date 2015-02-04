//
//  LevelWave.m
//  ImmuniFense
//
//  Created by Igor Domingues on 2/4/15.
//  Copyright (c) 2015 Group 9. All rights reserved.
//

#import "LevelWave.h"

@implementation LevelWave
{
    int level; //level corrente - ENUM
}

-(id) init
{
    return [level = 0];
}

-(id) initWithLevel: (int) lv
{
    return [level = lv];
}

-(NSMutableArray*) initWithWave:(int) wave
{
    NSMutableArray* creeps = [[NSMutableArray alloc]init];
    //Ler do arquivo com base no level e na wave e criar os creeps correspondentes
    return creeps;
}
@end
