//
//  Terrain.m
//  ImmuniFense
//
//  Created by Igor Domingues on 2/3/15.
//  Copyright (c) 2015 Group 9. All rights reserved.
//

#import "Terrain.h"

@implementation Terrain


-(id) initWithLevel:(int)theLevel andTowerSpot:(NSMutableArray *)theTowerS andPath:(CGMutablePathRef)thePath andMap:(SKSpriteNode *)theMap andCoins: (int)theCoins
{
    
    self = [super init];
    if(self)
    {
        self.level = theLevel;
        self.towerSpot = theTowerS;
        self.creepPath = thePath;
        self.map  = theMap;
    }
    return self;
}

+(Terrain*) initWithLevel:(int) theLevel
{
    int xt = 0;
    int yt = 0;
    int xp = 0;
    int yp = 0;
    int lv = 0;
    int coins = 0;
    CGPoint point = CGPointMake(xt, yt);
    Terrain* novo = [[Terrain alloc]init];
    char temp[200];
    SKSpriteNode *mapBackground = [[SKSpriteNode alloc]initWithImageNamed:[NSString stringWithFormat:@"Map%d",theLevel]];
    
    NSString * terrains = [[NSBundle mainBundle] pathForResource:@"TerrainIformation" ofType:@".txt"];
    
    FILE* terrain = fopen([terrains UTF8String], "r");
    
    while(fscanf(terrain, "%d", &lv))
    {
        novo.level = lv;
        if(novo.level == theLevel)
        {
            fscanf(terrain, "%d", &coins);
            novo.coins = coins;
            novo.creepPath = CGPathCreateMutable();
            fscanf(terrain, "%d", &xp);
            fscanf(terrain, "%d", &yp);
            if(xp==5000 && yp==5000){
                CGPathMoveToPoint(novo.creepPath, nil, xp, yp);
                fscanf(terrain, "%d", &xp);
                fscanf(terrain, "%d", &yp);
                
                while(xp==5000 && yp==5000)
                {
                    CGPathAddLineToPoint(novo.creepPath, nil, xp, yp);
                    fscanf(terrain, "%d", &xp);
                    fscanf(terrain, "%d", &yp);
                    
                }
            }
            fscanf(terrain, "%d", &xt);
            fscanf(terrain, "%d", &yt);
            while(xt==5000 && yt==5000)
            {
                point = CGPointMake(xt, yt);
                NSValue* pointV = [NSValue valueWithCGPoint:point];
                [novo.towerSpot addObject:pointV];
                fscanf(terrain, "%d", &xt);
                fscanf(terrain, "%d", &yt);
            }
        }
        else{
            fscanf(terrain, " %[^\n]", temp);
        }
    }
    novo.map = mapBackground;
    
    fclose(terrain);
    
    return novo;
}


@end

