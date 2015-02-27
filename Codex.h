//
//  Codex.h
//  ImmuniFense
//
//  Created by Igor Domingues on 2/9/15.
//  Copyright (c) 2015 Group 9. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Codex : SKScene

@property SKSpriteNode* background;
@property SKShapeNode* buttonicon1;
@property SKShapeNode* buttonicon2;
@property SKShapeNode* buttonicon3;

-(id)initWithSize:(CGSize)size;

@end