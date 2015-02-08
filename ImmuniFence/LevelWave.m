//
//  LevelWave.m
//  ImmuniFense
//
//  Created by Igor Domingues on 2/4/15.
//  Copyright (c) 2015 Group 9. All rights reserved.
//

#import "LevelWave.h"
#import "Creep.h"
#define MaxCreepTypes 30
#define MaxWaves 20

@implementation LevelWave

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


-(id) initWithLevel:(int) level
{
    
    //Criação do espaço necessario para guardar todos os valores
    self.waves = (int**)malloc(20*sizeof(int*));
    self.cooldown = (double*)malloc(20*sizeof(double));
    for(int n = 20;n>0;n--)
    {
        self.waves[n-1] = (int*)malloc(30*sizeof(int));
    }
    int i = 20;
    int j = 30;
    while(i>0)
    {
        while(j>0)
        {
            self.waves[i-1][j-1] = 0;
            j--;
        }
        self.cooldown[i-1] = 0.0;
        i--;
        j = 30;
    }
    self.level = level;
    self.numOfWaves = 0;
    
    int wv = 0;
    int lv = 0;
    int type = 0;
    int number = 0;
    char temp[200];
    //Ler do arquivo com base no level e preencher o LevelWave
    
    NSString * string = [[NSBundle mainBundle] pathForResource:@"Wavesinformation" ofType:@".txt"];
    
    FILE* waves = fopen([string UTF8String], "r");
    
    while(fscanf(waves, "%d", &lv))
    {
        
        if(lv == self.level)
        {
            fscanf(waves, "%d", &wv);//recebe a wave corrente
            self.numOfWaves++;  //incrementa o numero de waves no level
            fscanf(waves, "%lf", &self.cooldown[wv]);//guarda o cooldown para começar essa wave
            fscanf(waves, "%d", &type);
            while(type != 5000)
            {
                fscanf(waves, "%d", &number);
                self.waves[wv][type] = number;//guarda o numero de creeps de cada tipo em cada wave
                fscanf(waves, "%d", &type);
            }
        }
        
        else{
            fscanf(waves, " %[^\n]", temp);
        }
    }
    fclose(waves);
    
    return self;
}

-(NSMutableArray*) createCreepsForWave:(int)wave
{
    NSMutableArray *creeps = [[NSMutableArray alloc]init];
    for(int j = 0; j < 30; j++)
    {
        while(self.waves[wave][j]!=0)
        {
            Creep* novo = [Creep creepOfType: j];
            [creeps addObject:novo];
            self.waves[wave][j]--;
        }
    }
    
    return creeps;
}

-(NSTimeInterval) cooldownForWave:(int)wave
{
    return self.cooldown[wave];
}

@end

