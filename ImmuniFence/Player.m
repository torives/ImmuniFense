//
//  Player.m
//  ImmuniFense
//
//  Created by Igor Domingues on 2/4/15.
//  Copyright (c) 2015 Group 9. All rights reserved.
//

#import "Player.h"

@implementation Player


+ (id)singlePlayer {
    static Player *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (id)init {
    if (self = [super init]) {
        
        self.prescriptions = 0;
        self.levelsCleared = [[NSMutableArray alloc]init];
        self.itemList = [[NSDictionary alloc]init];
    }
    return self;
}

- (void)dealloc {
    //Should never be called, but just here for clarity really.
    
}

+(BOOL) loadData{
    //Le o arquivo, preenche o player
    return YES;
}

+(BOOL) saveData{
    //Grava os dados do player em um arquivo
    return YES;
}
@end
