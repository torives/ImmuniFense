//
//  BitMasks.h
//  ImmuniFense
//
//  Created by Victor Yves Crispim on 02/5/15.
//  Copyright (c) 2015 Group 9. All rights reserved.
//

#ifndef ImmuniFense_BitMasks_h
#define ImmuniFense_BitMasks_h

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(uint32_t, CollisionMask) {    
    CreepMask   = 1 << 0,   //0001
    TowerMask   = 1 << 1,   //0010
    BulletMask  = 1 << 2,   //0100
};

#endif