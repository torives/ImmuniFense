//
//  Terrain.m
//  ImmuniFense
//
//  Created by Igor Domingues on 2/3/15.
//  Copyright (c) 2015 Group 9. All rights reserved.
//

#import "Terrain.h"

@implementation Terrain


-(id) initWithName:(NSString *)theName andTowerSpot:(NSMutableArray *)theTowerS andPath:(CGMutablePathRef *)thePath andMap:(UIImage *)theMap
{
    
    self = [super init];
    if(self)
    {
        self.name = theName;
        self.towerSpot = theTowerS;
        self.path = thePath;
        self.map  = theMap;
    }
    return self;
}

-(id) init
{
    return ([self initWithName:@"" andTowerSpot:nil andPath:nil andMap:nil]);
}

-(id) initWithName:(NSString *)theName
{
    return ([self initWithName:theName andTowerSpot:nil andPath:nil andMap:nil]);
}


@end
