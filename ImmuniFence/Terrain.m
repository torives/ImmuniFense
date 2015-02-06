//
//  Terrain.m
//  ImmuniFense
//
//  Created by Igor Domingues on 2/3/15.
//  Copyright (c) 2015 Group 9. All rights reserved.
//

#import "Terrain.h"

@implementation Terrain


//-(id) initWithLevel:(int)theLevel andTowerSpot:(NSMutableArray *)theTowerS andPath:(CGMutablePathRef)thePath andMap:(SKSpriteNode *)theMap andCoins: (int)theCoins
//{
//    
//    self = [super init];
//    if(self)
//    {
//        self.level = theLevel;
//        self.towerSpot = theTowerS;
//        self.creeppath = thePath;
//        self.map  = theMap;
//    }
//    return self;
//}
//
//-(id) init
//{
//    return ([self initWithLevel:0 andTowerSpot:nil andPath:nil andMap:nil andCoins:0]);
//}

+(Terrain*) initWithLevel:(int) theLevel
{
    int xt = 0;
    int yt = 0;
    int xp = 0;
    int yp = 0;
    int lv = 0;
    CGPoint point = CGPointMake(xt, yt);
    Terrain* novo = [[Terrain alloc]init];
    char temp[200];
    SKSpriteNode *mapBackground = [[SKSpriteNode alloc]initWithImageNamed:[NSString stringWithFormat:@"Map%d",theLevel]];
    
    NSString * terrains = [[NSBundle mainBundle] pathForResource:@"terrain" ofType:@".txt"];
    
    FILE* terrain = fopen([terrains UTF8String], "r");
    
    while(fscanf(terrain, "%d", &lv))
    {
        novo.level = lv;
        if(novo.level == theLevel)
        {
            novo.creeppath = CGPathCreateMutable();
            fscanf(terrain, "%d", &xp);
            fscanf(terrain, "%d", &yp);
            if(xp>0 && yp>0){
                CGPathMoveToPoint(novo.creeppath, nil, xp, yp);
                fscanf(terrain, "%d", &xp);
                fscanf(terrain, "%d", &yp);
                
                while(xp>0 && yp>0)
                {
                    CGPathAddLineToPoint(novo.creeppath, nil, xp, yp);
                    fscanf(terrain, "%d", &xp);
                    fscanf(terrain, "%d", &yp);
                    
                }
            }
            fscanf(terrain, "%d", &xt);
            fscanf(terrain, "%d", &yt);
            while(xt>0 && yt>0)
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
