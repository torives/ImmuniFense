//
//  Terrain.m
//  ImmuniFense
//
//  Created by Igor Domingues on 2/3/15.
//  Copyright (c) 2015 Group 9. All rights reserved.
//

#import "Terrain.h"

@implementation Terrain


-(id) initWithLevel:(int)theLevel andTowerSpot:(NSMutableArray *)theTowerS andPath:(CGMutablePathRef)thePath andPath2:(CGMutablePathRef)thePath2 andMap:(SKSpriteNode *)theMap andCoins: (int)theCoins
{
    
    self = [super init];
    if(self)
    {
        self.level = theLevel;
        self.towerSpot = theTowerS;
        self.creepPath = thePath;
        self.map  = theMap;
        self.creepPath2 = thePath2;
    }
    
    printf("valor da veriável level na claase terrain %d ", theLevel);

    
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
    novo.towerSpot = [[NSMutableArray alloc] init];
    novo.creepPath = CGPathCreateMutable();
    novo.creepPath2 = CGPathCreateMutable();
    char temp[200];
    
    SKSpriteNode *mapBackground = [[SKSpriteNode alloc]initWithImageNamed:[NSString stringWithFormat:@"map%d.jpg",theLevel]];
    
//    printf("NÍVEL:%d ", theLevel);
    
    NSString * terrains = [[NSBundle mainBundle] pathForResource:@"TerrainInformation" ofType:@".txt"];
    
    FILE* terrain = fopen([terrains UTF8String], "r");
    
    while(!feof(terrain))
    {
        fscanf(terrain, "%d", &lv);
        novo.level = lv;
    
        if(novo.level == theLevel)
        {
            fscanf(terrain, "%d", &coins);
            novo.coins = coins;
            fscanf(terrain, "%d", &xp);
            fscanf(terrain, "%d", &yp);
        
            if(xp!=5000 && yp!=5000)
            {
                CGPathMoveToPoint(novo.creepPath, NULL, xp, yp);
                
                fscanf(terrain, "%d", &xp);
                fscanf(terrain, "%d", &yp);
                
                //printf("%d%d",xp,yp);
                while(xp!=5000 && yp!=5000)
                {
                    CGPathAddLineToPoint(novo.creepPath, NULL, xp, yp);

                    fscanf(terrain, "%d", &xp);
                    fscanf(terrain, "%d", &yp);
                    //printf("%d%d",xp,yp);
                }
                
            }
            fscanf(terrain, "%d", &xp);
            fscanf(terrain, "%d", &yp);
            
            if(xp!=5000 && yp!=5000)
            {
                CGPathMoveToPoint(novo.creepPath2, NULL, xp, yp);
                
                fscanf(terrain, "%d", &xp);
                fscanf(terrain, "%d", &yp);
                
                printf("%d%d",xp,yp);
                while(xp!=5000 && yp!=5000)
                {
                    CGPathAddLineToPoint(novo.creepPath2, NULL, xp, yp);
                    
                    fscanf(terrain, "%d", &xp);
                    fscanf(terrain, "%d", &yp);
                    //printf("%d%d",xp,yp);
                }
                
            }
            
            fscanf(terrain, "%d", &xt);
            fscanf(terrain, "%d", &yt);
            while(xt!=5000 && yt!=5000)
            {
                point = CGPointMake(xt, yt);
                NSValue* pointV = [NSValue valueWithCGPoint:point];
                [novo.towerSpot addObject:pointV];
                fscanf(terrain, "%d", &xt);
                fscanf(terrain, "%d", &yt);
                //printf("%d%d",xt,yt);
            }
        }
        else{
            fscanf(terrain, " %[^\n]", temp);
        }
    }
    novo.map = mapBackground;
    
    fclose(terrain);
    if (novo.creepPath2 == NULL)
    {
        printf("Entrou");
        novo.creepPath2 = novo.creepPath;
    }
    
    return novo;
}


@end

