//
//  LevelWave.h
//  ImmuniFense
//
//  Created by Igor Domingues on 2/4/15.
//  Copyright (c) 2015 Group 9. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LevelWave : NSObject

-(id) init;
-(id) initWithLevel: (int) lv;
-(NSMutableArray*) CreateWave:(int)wave;
+(NSDictionary*) Creeponary;

@end
