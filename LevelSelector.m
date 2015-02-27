//
//  LevelSelector.m
//  ImmuniFense
//
//  Created by Igor Domingues on 2/10/15.
//  Copyright (c) 2015 Group 9. All rights reserved.
//

#import "LevelSelector.h"
#import "Level.h"

@implementation LevelSelector


// if next button touched, start transition to next scene



-(id)initWithSize:(CGSize)size {
    
    if (self = [super initWithSize:size]) {
        
        /* Setup your scene here */
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"carlos.jpg"];
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        //        background.position = CGPointMake(0, 0);
        //        background.anchorPoint = CGPointMake(0, 0);
        background.yScale = 0.3;
        background.xScale = 0.3;
        
        [self addChild:background];
        
        //criação do botão de level1
        SKShapeNode *buttonlevel1 = [SKShapeNode shapeNodeWithRect: CGRectMake(-238, -183, 80, 80)];
        //buttonlevel1.fillColor = [SKColor redColor];
        buttonlevel1.hidden = YES;
        buttonlevel1.name = @"buttonlevel1";
        [background addChild:buttonlevel1];
        
        //criação do botão de level2
        SKShapeNode *buttonlevel2 = [SKShapeNode shapeNodeWithRect: CGRectMake(20, -410, 80, 80)];
        buttonlevel2.hidden = YES;
        //buttonlevel2.fillColor = [SKColor blackColor];
        buttonlevel2.name = @"buttonlevel2";
        [background addChild:buttonlevel2];
    }
    
    return self;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // percebe qualquer toque na tela.
    UITouch *touch = [touches anyObject];
    // ca
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    // if next button touched, start transition to next scene
    if ([node.name isEqualToString:@"buttonlevel1"]) {
        Level *newLevel = [Level createLevel: LevelOne withSize: self.frame.size];
        SKTransition *transition = [SKTransition crossFadeWithDuration:1.0];
        [self.view presentScene:newLevel transition:transition];
    }
    else if ([node.name isEqualToString:@"buttonlevel2"]) {
        Level *newLevel = [Level createLevel: LevelTwo withSize: self.frame.size];
        SKTransition *transition = [SKTransition crossFadeWithDuration:1.0];
        [self.view presentScene:newLevel transition:transition];
    }
    
}

@end
