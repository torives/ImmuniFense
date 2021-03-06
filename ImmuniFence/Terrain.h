//  Terrain.h
//  ImmuniFense
//
//  Created by Igor Domingues on 2/3/15.
//  Copyright (c) 2015 Group 9. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface Terrain : NSObject

@property int level;
@property (nonatomic, strong) NSMutableArray *towerSpot;
@property (nonatomic) CGMutablePathRef creepPath;
@property (nonatomic) CGMutablePathRef creepPath2;
@property (nonatomic, strong) SKSpriteNode *map;
@property int coins;


-(id) initWithLevel:(int)theLevel andTowerSpot:(NSMutableArray *)theTowerS andPath:(CGMutablePathRef)thePath andPath2:(CGMutablePathRef)thePath2 andMap:(SKSpriteNode *)theMap andCoins: (int)theCoins;

+(Terrain*) initWithLevel:(int) theLevel;


//O documento terrain.txt é o documento do qual os terrenos serão carregados
//Cada linha corresponde a um terreno
//O primeiro número corresponde ao level do terreno
//os numeros seguintes são lidos em pares, inicialmente os pares são as coordenadas dos pontos seguidos pelos creeps ate que o par 5000 5000 seja lido
//em seguida de modo similar são lidos os pontos de construção das torres, ate que o par 5000 5000 seja lido

@end
