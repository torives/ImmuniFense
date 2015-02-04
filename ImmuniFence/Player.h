//
//  Player.h
//  ImmuniFense
//
//  Created by Igor Domingues on 2/4/15.
//  Copyright (c) 2015 Group 9. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Player : NSObject

@property int prescriptions;
@property (nonatomic, strong) NSMutableArray *levelsCleared;
@property (nonatomic, strong) NSDictionary *itemList;

+(id) singlePlayer;
+(BOOL) saveData;
+(BOOL) loadData;
@end