//
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
@property (nonatomic, strong) NSString *name
@property (nonatomic, strong) NSMutableArray *towerSpot;
@property (nonatomic) CGMutablePathRef *path;
@property (nonatomic, strong) UIImage *map;

-(id) initWithName:(NSString *)theName;

-(id) initWithName:(NSString *)theName andTowerSpot:(NSMutableArray *)theTowerS andPath:(CGMutablePathRef *)thePath andMap:(UIImage *)theMap;

@end
