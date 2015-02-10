//
//  Codex.m
//  ImmuniFense
//
//  Created by Igor Domingues on 2/9/15.
//  Copyright (c) 2015 Group 9. All rights reserved.
//

#import "Codex.h"
#import "MainMenu.h"


@implementation Codex
{
    int menu;
}

-(id)initWithSize:(CGSize)size {
    
    if (self = [super initWithSize:size]) {
        
        menu=0;
        self.background = [SKSpriteNode spriteNodeWithImageNamed:@"codex"];
        self.background.position = CGPointMake(0,0);
        self.background.anchorPoint = CGPointMake(0, 0);
        self.background.yScale = 0.265;
        self.background.xScale = 0.265;
        [self addChild: self.background];
        
        SKShapeNode *buttonBody = [SKShapeNode shapeNodeWithRect:CGRectMake(630, 1100, 180, 80)];
        //buttonBody.fillColor = [SKColor greenColor];
        buttonBody.name = @"Body";
        buttonBody.hidden = YES;
        [ self.background addChild:buttonBody];
        
        
        SKShapeNode *buttonDefense = [SKShapeNode shapeNodeWithRect: CGRectMake(342, 1100, 250, 80)];
        //buttonDefense.fillColor = [SKColor blackColor];
        buttonDefense.hidden = YES;
        buttonDefense.name = @"Defense";
        [ self.background addChild:buttonDefense];
        
        SKShapeNode *buttonCreeps = [SKShapeNode shapeNodeWithRect: CGRectMake(120, 1100, 180, 80)];
        //buttonCreeps.fillColor = [SKColor blueColor];
        buttonCreeps.hidden = YES;
        buttonCreeps.name = @"Creeps";
        [ self.background addChild:buttonCreeps];
        
        SKShapeNode *buttonBack = [SKShapeNode shapeNodeWithRect: CGRectMake(2005, 1110, 100, 100)];
        //buttonBack.fillColor = [SKColor blueColor];
        buttonBack.hidden = YES;
        buttonBack.name = @"Back";
        [ self.background addChild:buttonBack];

        
        self.buttonicon1 = [SKShapeNode shapeNodeWithRect: CGRectMake(140, 980, 320, 80)];
        //self.buttonicon1.fillColor = [SKColor yellowColor];
        self.buttonicon1.hidden = YES;
        if(menu == 0)
        {
            self.buttonicon1.name = @"Influenza";
        }
        else{
            self.buttonicon1.name = @"Bcell";
        }
        [ self.background addChild:self.buttonicon1];
        
        
        
        self.buttonicon2 = [SKShapeNode shapeNodeWithRect: CGRectMake(140, 890, 320, 80)];
        //self.buttonicon2.fillColor = [SKColor purpleColor];
        self.buttonicon2.hidden = YES;
        if(menu == 0)
        {
            self.buttonicon2.name = @"Staphy";
        }
        else
        {
            self.buttonicon2.name = @"Tkiller";
        }
        [ self.background addChild:self.buttonicon2];
        
        self.buttonicon3 = [SKShapeNode shapeNodeWithRect: CGRectMake(140, 800, 320, 80)];
        //self.buttonicon3.fillColor = [SKColor redColor];
        self.buttonicon3.hidden = YES;
        if(menu == 0)
        {
            self.buttonicon3.name = @"lalala";
        }
        else
        {
            self.buttonicon3.name = @"Macro";
        }
        [self.background addChild:self.buttonicon3];
        
        
    }
    return self;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //
    // percebe qualquer toque na tela.
    UITouch *touch = [touches anyObject];
    // ca
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    // if next button touched, start transition to next scene
    if ([node.name isEqualToString:@"Body"]) {
        [self.background setTexture:[SKTexture textureWithImageNamed:@"codex"]];
        menu = 0;
        [self nameSeter];
    }
    else  if ([node.name isEqualToString:@"Defense"]) {
        [self.background setTexture:[SKTexture textureWithImageNamed:@"codex3.png"]];
        menu = 1;
        [self nameSeter];
    }
    else  if ([node.name isEqualToString:@"Creeps"]) {
        [self.background setTexture:[SKTexture textureWithImageNamed:@"codex"]];
        menu = 0;
        [self nameSeter];
    }
    else  if ([node.name isEqualToString:@"Influenza"]) {
        [self.background setTexture:[SKTexture textureWithImageNamed:@"codex"]];
        menu = 0;
        [self nameSeter];
    }
    else  if ([node.name isEqualToString:@"Bcell"]) {
        [self.background setTexture:[SKTexture textureWithImageNamed:@"codex3"]];
        menu = 1;
        [self nameSeter];
    }
    else  if ([node.name isEqualToString:@"Staphy"]) {
        [self.background setTexture:[SKTexture textureWithImageNamed:@"codex2"]];
        menu = 0;
        [self nameSeter];
    }
    else  if ([node.name isEqualToString:@"Tkiller"]) {
        [self.background setTexture:[SKTexture textureWithImageNamed:@"codex5"]];
        menu = 1;
        [self nameSeter];
    }
    else if ([node.name isEqualToString:@"Macro"]) {
        [self.background setTexture:[SKTexture textureWithImageNamed:@"codex4"]];
        menu = 1;
        [self nameSeter];
    }
    else if ([node.name isEqualToString:@"Back"]) {
        SKView * view = (SKView *)self.view;
        
        // Create and configure the scene.
        SKScene * mainMenu = [MainMenu sceneWithSize:view.frame.size];
        mainMenu.scaleMode = SKSceneScaleModeResizeFill;
        
        // Present the scene.
        [view presentScene:mainMenu];

    }

    
}

-(void)nameSeter
{
    if(menu == 0)
    {
        self.buttonicon1.name= @"Influenza";
        
        self.buttonicon2.name= @"Staphy";
        
        self.buttonicon3.name= @"lalala";
    }
    else
    {
        self.buttonicon1.name= @"Bcell";
        
        self.buttonicon2.name= @"Tkiller";
        
        self.buttonicon3.name= @"Macro";
    }
}


@end
