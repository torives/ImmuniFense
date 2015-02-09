//
//  Title.m
//  ImmuniFense
//
//  Created by Mayara Coelho on 2/9/15.
//  Copyright (c) 2015 Group 9. All rights reserved.
//

#import "Title.h"
#import "Level.h"

@implementation Title

-(id)initWithSize:(CGSize)size {
    
    if (self = [super initWithSize:size]) {
        
        /* Setup your scene here */
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"logscreen2.jpg"];
        background.position = CGPointMake(0, 0);
        background.anchorPoint = CGPointMake(0, 0);
        background.yScale = 0.3;
        background.xScale = 0.3;
        
        [self addChild:background];
        
        //criação do botão de play game
        SKShapeNode *buttonplay = [SKShapeNode shapeNodeWithRect: CGRectMake(320, 200, 144, 45)];
        buttonplay.hidden = YES;
        buttonplay.name = @"playButton";
        [self addChild:buttonplay];
        
        //criação do botão de codex
        SKShapeNode *buttoncodex = [SKShapeNode shapeNodeWithRect: CGRectMake(275, 129, 120, 43)];
        buttoncodex.hidden = YES;
        buttoncodex.name = @"codexButton";
        [self addChild:buttoncodex];
        
        //criação do botão de drogstore
        SKShapeNode *button = [SKShapeNode shapeNodeWithRect: CGRectMake(320, 200, 144, 45)];
        button.hidden = YES;
        button.name = @"playButton";
        [self addChild:button];
        
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
    if ([node.name isEqualToString:@"playButton"]) {
        NSLog(@"playButton pressed");
        Level *playerScene = [Level sceneWithSize: self.frame.size];
        SKTransition *transition = [SKTransition crossFadeWithDuration:1.0];
        [self.view presentScene:playerScene transition:transition];
    }
}
@end
