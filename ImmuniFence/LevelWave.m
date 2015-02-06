//
//  LevelWave.m
//  ImmuniFense
//
//  Created by Igor Domingues on 2/4/15.
//  Copyright (c) 2015 Group 9. All rights reserved.
//

#import "LevelWave.h"
#import "Creep.h"

@interface Wave : NSObject

@property (nonatomic) NSMutableArray *tiposCreep;
@property (nonatomic) NSTimeInterval cooldown;

@end

//@implementation Wave
//
//-(id) init{
//    
//    Wave* newWave = [[Wave alloc] init];
//
//}
//
//@end


@implementation LevelWave{
    
    NSMutableArray *wavesArray;
}


+(LevelWave *) wavesForLevel:(LevelName)level{
    
    char auxChar;
    int auxInt;
    
    LevelWave *waveInfo = [[LevelWave alloc] init];
    
    waveInfo->wavesArray = [[NSMutableArray alloc] init];
    
    NSString * string = [[NSBundle mainBundle]
                         pathForResource:@"WavesInformation" ofType:@".txt"];
    
    FILE* wavesFile = fopen([string UTF8String], "r");
    
    while(fscanf(wavesFile, " %c", &auxChar)){
        
        if (auxChar == 'L'){
        
            auxInt = getchar();
            if (auxInt == level){
                
                int num_waves = getchar();
                
                for (int i = 0; i < num_waves; i++) {
                    
                    Wave * newWave = [[Wave alloc]init];
                    
                    fscanf(wavesFile, "%c", &auxChar);
                    
                    while (auxChar != 'C') {
                    
                        fscanf(wavesFile, "%d", &auxInt);
                        [newWave.tiposCreep addObject: [NSNumber numberWithInt:auxInt]];

                    }
                }
            }
        }
    }
    
    return waveInfo;
}


-(int) numberOfWaves{
    
    return wavesArray.count;
    
}

-(NSTimeInterval) cooldownForWave: (int) wave{

    Wave* waveInfo = (Wave*)[wavesArray objectAtIndex:wave];
    return waveInfo.cooldown;
    
}

-(NSMutableArray *) createCreepsForWave: (int) wave{
    
}



-(NSMutableArray*) CreateWave:(int) wave
{
    int *todo = (int*)malloc(sizeof(int));
    
    NSMutableArray *creeps = [[NSMutableArray alloc]init];
    
    int wv = 0;
    int lv = 0;
    
    int type = 0;
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
                while(type != 0)
                {
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
    

    int i = 0;
    
    while (i < 30)
    {
        for(int j = 0; j < todo[i]; j++)
        {
            if (i!=0) {
                Creep* novo = [Creep creepOfType: i];
                [creeps addObject:novo];
            }
            
        }
    }
    
    return creeps;
}

//+(int**) Creeponary
//{
//    NSArray *keys = [NSArray arrayWithObjects:@"1", @"2",@"3", nil];
//    NSArray *values = [NSArray arrayWithObjects:@"0", @"0",@"0", nil];
//    NSDictionary *novo = [NSDictionary dictionaryWithObjects:values
//                                                     forKeys:keys];
//    for (id key in novo) {
//        NSLog(@"key: %@, value: %@", key, [novo objectForKey:key]);
//    }
//
//    return novo;
//}
@end
