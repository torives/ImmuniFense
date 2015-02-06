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
    return self;
}

-(id) initWithLevel: (int) lv
{
    level = lv;
    return self;
}

//+(int**) Creeponary
//{
////    NSArray *keys = [NSArray arrayWithObjects:@"1", @"2",@"3", nil];
////    NSArray *values = [NSArray arrayWithObjects:@"0", @"0",@"0", nil];
////    NSDictionary *novo = [NSDictionary dictionaryWithObjects:values
////                                                     forKeys:keys];
////    for (id key in novo) {
////        NSLog(@"key: %@, value: %@", key, [novo objectForKey:key]);
////    }
////    
//    return novo;
//}

-(NSMutableArray*) CreateWave:(int) wave
{
    int *todo = (int*)malloc(sizeof(int));
    
    NSMutableArray *creeps = [[NSMutableArray alloc]init];
    
    int wv = 0;
    int lv = 0;
    
    int type = 0;
    int i = 0;
    int number = 0;
    char temp[200];
    //Ler do arquivo com base no level e na wave e criar os creeps correspondentes
    
    NSString * string = [[NSBundle mainBundle] pathForResource:@"waves" ofType:@".txt"];
    
    FILE* waves = fopen([string UTF8String], "r");
    
    while(fscanf(waves, "%d", &lv))
    {
        
        if(lv == level)
        {
            fscanf(waves, "%d", &wv);
            if(wv == wave)
            {
                
                fscanf(waves, "%d", &type);
                while(type != 5000)
                {
                    i=type;
                    fscanf(waves, "%d", &number);
                    todo[type] = number;
                }
            }
        }
        else{
            fscanf(waves, " %[^\n]", temp);
        }
    }
    
    //Carrega os Creeps em um vetor de quantidades
    
    //Começa a criação dos creeps
    

    
    
    
    while (i>0)
    {
        for(int j = 0; j < todo[i]; j++)
        {
            if (i!=0) {
                Creep* novo = [Creep creepOfType: i];
                [creeps addObject:novo];
            }
            i--;
        }
    }
    
    return creeps;
}

@end
