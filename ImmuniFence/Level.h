//
//  Level.h
//  ImmuniFense
//
//  Created by Victor Yves Crispim on 02/5/15.
//  Copyright (c) 2015 Group 9. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "LevelNames.h"

@interface Level : SKScene <SKPhysicsContactDelegate>

@property int level;

+(instancetype) createLevel: (LevelName) levelName withSize:(CGSize)size;

@end
