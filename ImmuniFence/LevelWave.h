//
//  LevelWave.h
//  ImmuniFense
//
//  Created by Igor Domingues on 2/4/15.
//  Copyright (c) 2015 Group 9. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LevelWave : NSObject

@property int** waves;
@property int numberOfWaves;
@property int level;
@property double* cooldown;



-(id) initWithLevel:(int) level;
-(NSMutableArray*) createCreepsForWave:(int)wave;
-(NSTimeInterval) cooldownForWave:(int)wave;


//O documento wave.txt é o documento do qual os as waves de cada level serão carregadas
//Cada linha corresponde a uma wave
//O primeiro número corresponde ao level da wave
//O segundo número corresponde ao número da wave
//O terceiro número corresponde ao cooldown de cada wave
//os numeros seguintes são lidos em pares, os pares são o primeiro número o tipo do creep e o segundo a quantidade de creeps daquele tipo, ate que o tipo 5000 seja lido

@end

