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


-(id) initWithLevel:(int) level
{
    
    //Criação do espaço necessario para guardar todos os valores
    self.waves = (int**)malloc(20*sizeof(int*));
    self.cooldown = (double*)malloc(20*sizeof(double));
    self.numberCreepsOnWave = (int*)malloc(20*sizeof(int));
    
    for(int n = 20;n>0;n--)
    {
        self.waves[n-1] = (int*)malloc(30*sizeof(int));
        self.numberCreepsOnWave[n-1] = 0;
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
//    printf("level na classe level wave %d ", level);
    self.numberOfWaves = 0;
    
    int wv = 0;
    int lv = 0;
    int type = 0;
    int number = 0;
    char temp[200];
    //Ler do arquivo com base no level e preencher o LevelWave
    
    NSString * string = [[NSBundle mainBundle] pathForResource:@"WavesInformation" ofType:@".txt"];
    
    FILE* waves = fopen([string UTF8String], "r");
    
    while(!feof(waves))
    {
        fscanf(waves, "%d", &lv);
        if(lv == self.level)
        {
            fscanf(waves, "%d", &wv);//recebe a wave corrente
            self.numberOfWaves++;  //incrementa o numero de waves no level
            fscanf(waves, "%lf", &self.cooldown[wv]);//guarda o cooldown para começar essa wave
            
            printf("%lf\n",self.cooldown[wv]);
            
            fscanf(waves, "%d", &type);
            
            while(type != 5000)
            {
                fscanf(waves, "%d", &number);
                self.waves[wv][type] = number;//guarda o numero de creeps de cada tipo em cada wave
                self.numberCreepsOnWave[wv] += number;
                printf("%d\n",self.waves[wv][type]);
                
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
    // não passa aqui na fase 2.
    printf("teste na classe levelwave");
    
    NSMutableArray *creeps = [[NSMutableArray alloc]init];
    for(int j = 0; j < 30; j++)
    {
        while(self.waves[wave][j]!=0)
        {
            Creep* novo = [Creep creepOfType: j];
            [creeps addObject:novo];
            
            self.waves[wave][j]--;
//            printf("waves na classe level wave %d  e valor do j %d", wave, j);

        }
    }
    
    return creeps;
}

-(NSTimeInterval) cooldownForWave:(int)wave
{
    return self.cooldown[wave];
}

-(int) numberOfCreepsForWave: (int)wave{
     return self.numberCreepsOnWave[wave];
}

@end

