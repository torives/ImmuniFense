//
//  LevelWave.h
//  ImmuniFense
//
//  Created by Igor Domingues on 2/4/15.
//  Copyright (c) 2015 Group 9. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LevelNames.h"

@interface LevelWave : NSObject

+(LevelWave *) wavesForLevel: (LevelName) level;

-(int) numberOfWaves;
-(NSTimeInterval) cooldownForWave: (int) wave;
-(NSMutableArray *) createCreepsForWave: (int) wave;

//-(id) init;
//-(id) initWithLevel: (int) lv;
//-(NSMutableArray*) CreateWave:(int)wave;
//+(NSDictionary*) Creeponary;

//O documento wave.txt é o documento do qual os as waves de cada level serão carregadas
//Cada linha corresponde a uma wave
//O primeiro número corresponde ao level da wave
//O segundo número corresponde ao número da wave
//os numeros seguintes são lidos em pares, os pares são o primeiro número o tipo do creep e o segundo a quantidade de creeps daquele tipo, ate que o par 0 0 seja lido




//  level    n_waves    tipoCreep   qntCreep   tipoCreep   qntCreep  coolDown
//  L1       2          T1          10         T2          2         C10
//  L2       1
@end
