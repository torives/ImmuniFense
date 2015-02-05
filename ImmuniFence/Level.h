//
//  Level.h
//  ImmuniFense
//
//  Created by Victor Yves Crispim on 02/5/15.
//  Copyright (c) 2015 Group 9. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM (NSUInteger, LevelName) {
    
    LevelOne = 1,
    LevelTwo = 2,
    LevelThree = 3,
    
};


@interface Level : SKScene <SKPhysicsContactDelegate>

+(instancetype) createLevel: (LevelName) levelName withSize:(CGSize)size;

@end
