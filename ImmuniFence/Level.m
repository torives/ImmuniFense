//
//  Level.m
//  ImmuniFense
//
//  Created by Victor Yves Crispim on 02/5/15.
//  Copyright (c) 2015 Group 9. All rights reserved.
//

#import "Level.h"
#import "BitMasks.h"
#import "LevelWave.h"
#import "Terrain.h"
#import "Creep.h"
#import "Tower.h"
#import "GameWin.h"
#import "GameOver.h"

//TODO  implementar o ingame menu
//TODO  implementar a pausa do jogo.

@interface Level ()

-(void) createHud;
-(void) addCreep;
-(void) updateHealthIndicator;
-(void) updateCoinIndicator;
-(void) discountHealth: (Creep *) creep;
-(void) gameOver;
-(void) gameWin;
-(void)addTowerIcons;

@end

@implementation Level{
    
    int level;
    int pathCount;
    int health;
    int currentWave;
    int coins;
    LevelWave *levelOneWaves;
    LevelWave *levelTwoWaves;
    NSMutableArray *towerSpots;
    NSMutableArray *activeCreeps;
    CGMutablePathRef path;
    NSTimeInterval timeOfLastMove;
    NSTimeInterval currentWaveCooldown;
    int lastCreepIndex;
    int livingCreeps;
    
    
    BOOL isIconSelected;
    SKSpriteNode* selectedSprite;
    //NSMutableArray *towerBaseBounds;
    NSMutableArray *towers;
}


/*****************************
*
*  Métodos de SKScene
*
***/

+ (instancetype)createLevel: (LevelName) levelName withSize:(CGSize)size{
    
    Level *lvl = [super sceneWithSize:size];
    
    //inicializa oq dá pra inicializar por aqui com arquivo
    
    //inicializa as variáveis da fase
    lvl->health = 20;
    lvl->currentWave = 1;
    lvl->lastCreepIndex = 0;
    lvl->livingCreeps = 0;
    lvl->isIconSelected = NO;
    lvl->pathCount = 0;
    lvl->level = levelName;
        
    //se registra como delegate de contato para tratar das colisões
    lvl.physicsWorld.contactDelegate = lvl;
    printf("LEVEL NAME  da classe level %d ", levelName);
    
    return lvl;
}


-(void) didMoveToView:(SKView *)view{
    
    //define o mapa da fase
   
    if (level == 1){
    
    Terrain *levelOneTerrain = [Terrain initWithLevel:LevelOne];
    SKSpriteNode* map = levelOneTerrain.map;
    map.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    map.yScale = 0.3;
    map.xScale = 0.3;
    [self addChild: map];
    coins = levelOneTerrain.coins;
    self.terrain = levelOneTerrain;
    
    NSLog(@"terminou terreno");
    //cria o HUD do jogo
    [self createHud];
    

    //cria os placeholders para criar as torres
    towerSpots = levelOneTerrain.towerSpot;
    for ( NSValue *value in towerSpots) {
        
        //NSValue *getPoint = [towerSpots objectAtIndex:i];
        CGPoint towerSpot = [value CGPointValue];
        
        SKShapeNode *towerSpawnPoint = [SKShapeNode shapeNodeWithCircleOfRadius:45];
        towerSpawnPoint.hidden = YES;
        //towerSpawnPoint.fillColor = [SKColor blackColor];
        towerSpawnPoint.name = @"towerSpawnPoint";
        
        //TODO Pode dar merda pq a posição tem que ser de acordo com o sistema de coordenadas do pai. Conferir isso.
        towerSpawnPoint.position = towerSpot;
        //adiciona o spawn point ao mapa
        [self addChild:towerSpawnPoint];
    }
    
    //adiciona os icones para adição das torres
    [self addTowerIcons];
    
    //guarda o path pra usar com a velocidade diferente de cada creep
    path = levelOneTerrain.creepPath;
    
    //pega a referencia para as waves da fase
    levelOneWaves = [[LevelWave alloc]initWithLevel: LevelOne];
  
    //descobre o tempo de espera para chamar a próxima wave
    //currentWaveCooldown = [levelOneWaves cooldownForWave: currentWave];
     pathCount++;
    //inicializa o vetor de creeps ativas
    activeCreeps = [[NSMutableArray alloc] init];
    towers = [[NSMutableArray alloc]init];
    
    SKAction *wait = [SKAction waitForDuration: [levelOneWaves cooldownForWave: currentWave]];
    SKAction *performSelector = [SKAction performSelector:@selector(addCreepWave) onTarget:self];
    SKAction *sequence = [SKAction sequence:@[performSelector, wait]];
    SKAction *repeat   = [SKAction repeatAction:sequence count: levelOneWaves.numberOfWaves];
    
    [self runAction:repeat];
    }
    
    else if(level == 2){
        
        Terrain *levelTwoTerrain = [Terrain initWithLevel:LevelTwo];
        SKSpriteNode* map = levelTwoTerrain.map;
        map.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        map.yScale = 0.3;
        map.xScale = 0.3;
        [self addChild: map];
        coins = levelTwoTerrain.coins;
        self.terrain = levelTwoTerrain;
        
        NSLog(@"terminou terreno");
        //cria o HUD do jogo
        [self createHud];
        
        
        //cria os placeholders para criar as torres
        towerSpots = levelTwoTerrain.towerSpot;
        for ( NSValue *value in towerSpots) {
            
//            NSValue *getPoint = [towerSpots objectAtIndex:i];
            CGPoint towerSpot = [value CGPointValue];
            
            SKShapeNode *towerSpawnPoint = [SKShapeNode shapeNodeWithCircleOfRadius:45];
            towerSpawnPoint.hidden = YES;
//            towerSpawnPoint.fillColor = [SKColor blackColor];
            towerSpawnPoint.name = @"towerSpawnPoint";
            
            //TODO Pode dar merda pq a posição tem que ser de acordo com o sistema de coordenadas do pai. Conferir isso.
            towerSpawnPoint.position = towerSpot;
            //adiciona o spawn point ao mapa
            [self addChild:towerSpawnPoint];
        }

        //adiciona os icones para adição das torres
        [self addTowerIcons];

        //guarda o path pra usar com a velocidade diferente de cada creep
        path = levelTwoTerrain.creepPath;

        //pega a referencia para as waves da fase
        levelTwoWaves = [[LevelWave alloc]initWithLevel: LevelTwo];

        //descobre o tempo de espera para chamar a próxima wave
        //currentWaveCooldown = [levelOneWaves cooldownForWave: currentWave];
        pathCount++;
        //inicializa o vetor de creeps ativas
        activeCreeps = [[NSMutableArray alloc] init];
        towers = [[NSMutableArray alloc]init];

        SKAction *wait = [SKAction waitForDuration: [levelTwoWaves cooldownForWave: currentWave]];
        SKAction *performSelector = [SKAction performSelector:@selector(addCreepWave) onTarget:self];
        SKAction *sequence = [SKAction sequence:@[performSelector, wait]];
        SKAction *repeat   = [SKAction repeatAction:sequence count: levelTwoWaves.numberOfWaves];
        
        printf("número de waves no level 2 %d ", levelTwoWaves.numberOfWaves);
        
        
// O PROBLEMA ESTÁ QUANDO A RUNACTION: REPEAT é chamada
//        [self runAction:repeat];
    }
}

-(void) update:(NSTimeInterval)currentTime{
    
    //atualiza o sprite dos creeps de acordo com a direção que eles seguem
    [self enumerateChildNodesWithName:@"creep" usingBlock:^(SKNode *node, BOOL *stop){
        
        Creep *creep = (Creep *) node;
        [creep updateAnimation];
    }];
    
    timeOfLastMove = currentTime;
    
}


/*****************************************************
*
*  Métodos de SKPhysicsContactDelegate
*
*  Utilizados para tratar as colisões entre os nós.
*  No caso, um creep entrando no alcance de uma torre
*  ou um projétil de torre acertando um creep
*
***/

//Chamado quando dois corpos iniciam contato
-(void) didBeginContact:(SKPhysicsContact *)contact{
    
    SKPhysicsBody* firstBody;
    SKPhysicsBody* secondBody;
    
    //diferencia os corpos pelo BitMask, colocando sempre em ordem crescente
    //creep < tower < bullet
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask){
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    
    else{
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    //se um creep entrou em contato com o corpo da torre (seu alcance), ele se torna um alvo
    if (firstBody.categoryBitMask == CreepMask && secondBody.categoryBitMask == TowerMask) {
        
        Creep *creep = (Creep *) firstBody.node;
        Tower *tower = (Tower *) secondBody.node;
        [tower.targets addObject:creep];
        
        
        SKAction *wait = [SKAction waitForDuration:tower.fireRate];
        SKAction *shoot = [SKAction performSelector:@selector(shootAtTarget) onTarget:tower];
        SKAction *sequence = [SKAction sequence:@[shoot, wait]];
        SKAction *repeat   = [SKAction repeatActionForever:sequence];
        [self runAction: repeat];
        
    }
    //se um projétil atingiu um creep, desconta o dano da torre
    else if (firstBody.categoryBitMask == CreepMask && secondBody.categoryBitMask == BulletMask) {
        
        Creep *creep = (Creep *) firstBody.node;
        Tower *tower = (Tower *) secondBody.node.parent;
        
        if (creep.hitPoints > 0) {
            //aplica o dano
            creep.hitPoints -= tower.damage;
            NSLog(@"bala atingiu alvo");
            //se creep morreu
            if (creep.hitPoints <= 0) {
                
                [tower.targets removeObject:creep];
                
                //incrementa as coins
                coins += creep.reward;
                //atualiza o HUD
                [self updateCoinIndicator];
                //retira o creep da cena
                [creep removeFromParent];
                //retira o creep da relação de creeps vivos
                //[activeCreeps removeObject: creep];
                livingCreeps--;
                
                //Se não há creeps ativos e acabaram as waves
                if (livingCreeps == 0 && currentWave >= [levelOneWaves numberOfWaves]){
                    
                    [self gameWin];
                }
            }
        }
    }
}

//Chamado quando dois corpos terminam o contato
-(void) didEndContact:(SKPhysicsContact *) contact{
    
    SKPhysicsBody *firstBody;
    SKPhysicsBody *secondBody;
    
    //diferencia os corpos pelo BitMask, colocando sempre em ordem crescente
    //creep < tower < bullet
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask){
        
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    
    else{
        
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    //se o creep não está mais em contato (alcance) da torre, o retira do vetor de alvos da torre
    if (firstBody.categoryBitMask == CreepMask && secondBody.categoryBitMask == TowerMask) {
        
        Creep *creep = (Creep *) firstBody.node;
        Tower *tower = (Tower *) secondBody.node;
        [tower.targets removeObject:creep];
    }
}


/**************************************************
*
*  Métodos de UIResponder
*
*  Utilizados para tratar da interação do usuário
*  com a interface do jogo
*
***/

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    [self selectNodeForTouch:positionInScene];
    
}

// editando AQUI
-(void)selectNodeForTouch:(CGPoint)touchLocation{
    
    SKSpriteNode *touchedNode = (SKSpriteNode*)[self nodeAtPoint:touchLocation];
    
    if ([touchedNode.name isEqualToString:@"towerIcon"]) {
        
        if (isIconSelected) {

            [touchedNode setScale:0.08f];
            isIconSelected = NO;
            selectedSprite = nil;
        }
        else{
            isIconSelected = YES;
            selectedSprite = touchedNode;
            [selectedSprite setScale:0.2f];
        }
    }
    else if ([touchedNode.name isEqualToString:@"towerSpawnPoint"]){
        
        if ( isIconSelected && coins >= [[selectedSprite.userData objectForKey:@"cost"]intValue]) {
            
            Tower* newTower = [Tower createTowerOfType: [[selectedSprite.userData objectForKey: @"type"] intValue] withLevel:1];
            
            [towers addObject:newTower];
            newTower.position = touchedNode.position;
            [self addChild:newTower];
            
            [towerSpots removeObject: [NSValue valueWithCGPoint: touchedNode.position]];
            coins -= [[selectedSprite.userData objectForKey:@"cost"]intValue];
            [self updateCoinIndicator];
            
            [selectedSprite setScale:0.08f];
            isIconSelected = NO;
            selectedSprite = nil;
        }
    }
}


/***************************************
*
*  Métodos Auxiliares
*
***/

//cria os indicadores de vida e moedas
//TODO o HUD deve ser uma classe (ou várias) específicas, para encapsular a arte
//TODO posicioná-los usando proporções, não hardcoded
-(void) createHud{
    
    //cria o indicador de vida
    SKSpriteNode *healthIndicator = [SKSpriteNode spriteNodeWithImageNamed: @"health_hud"];
    healthIndicator.position = CGPointMake(60,CGRectGetMaxY(self.frame)-30);
    healthIndicator.xScale = 0.3;
    healthIndicator.yScale = 0.3;
    healthIndicator.name = @"healthIndicator";
    
    //Cria label de vida
    SKLabelNode *healthLabel = [SKLabelNode labelNodeWithFontNamed:@"Menlo-Regular"];
    healthLabel.text = [NSString stringWithFormat:@"%d", health];
    healthLabel.fontSize = 14;
    healthLabel.fontColor = [SKColor blackColor];
    healthLabel.position = CGPointMake(70,CGRectGetMaxY(self.frame)-38);
    healthLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    healthLabel.name = @"healthLabel";
    
    //adiciona o indicator a cena
    [self addChild: healthIndicator];
    //adiciona a label ao indicator
    [self addChild:healthLabel];

    //Cria o indicador de moedas
    SKSpriteNode *coinIndicator = [SKSpriteNode spriteNodeWithImageNamed:@"coin_hud"];
    coinIndicator.position = CGPointMake(190,CGRectGetMaxY(self.frame)-30);
    coinIndicator.xScale = 0.3;
    coinIndicator.yScale = 0.3;
    coinIndicator.name = @"coinIndicator";
    
    //Cria label de coins
    SKLabelNode *coinLabel = [SKLabelNode labelNodeWithFontNamed:@"Menlo-Regular"];
    coinLabel.text = [NSString stringWithFormat:@"%d", coins];
    coinLabel.fontSize = 14;
    coinLabel.fontColor = [SKColor blackColor];
    coinLabel.position = CGPointMake(210,CGRectGetMaxY(self.frame)-38);
    coinLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    coinLabel.name = @"coinLabel";
   
    //adiciona o indicador a cena
    [self addChild: coinIndicator];
    //adiciona a label ao indicador
    [self addChild:coinLabel];
   
}

//chamado quando um creep atravessa a linha de defesa.
//TODO no futuro, esse método deve penalizar o jogador caso muitos creeps ultrapassem.
//TODO conferir se é aqui mesmo que tem que liberar o CGMutablePath da memória
-(void)discountHealth: (Creep *) creep{
    
    //TODO tem que conferir se esse typecast aqui não vai dar merda
    health -= creep.damage;
    
    //Se a vida zerar, é Game Over
    if (health <= 0){
        
        [self gameOver];
        return;
    }
    
    //Atualiza o HUD
    [self updateHealthIndicator];
    //retira o creep da cena
    [creep removeFromParent];

    livingCreeps--;
    
    //Se não há creeps ativos e acabaram as waves
    if (livingCreeps == 0 && currentWave >= [levelOneWaves numberOfWaves]){
        
        //TODO game win
        [self gameWin];
    }
}

-(void) updateHealthIndicator{
    
   // SKNode *healthIndicator = [self childNodeWithName:@"healthIndicator"];
    SKLabelNode *healthLabel = (SKLabelNode*)[self childNodeWithName:@"healthLabel"];
    healthLabel.text = [NSString stringWithFormat:@"%d", health];
    NSLog(@"Health Updated");
}

-(void) updateCoinIndicator{
    
    //SKNode *coinIndicator = [self childNodeWithName:@"coinIndicator"];
    SKLabelNode *coinLabel = (SKLabelNode*)[self childNodeWithName:@"coinLabel"];
    coinLabel.text = [NSString stringWithFormat:@"%d", coins];
    NSLog(@"Coins Updated");
}

-(void)addCreepWave{
   
    //instancia os creeps da primeira wave e os guarda no vetor de creeps
    [activeCreeps addObjectsFromArray:[levelOneWaves createCreepsForWave: currentWave]];
    
    int creepsOnWave = [levelOneWaves numberOfCreepsForWave: currentWave];
    
    SKAction *wait = [SKAction waitForDuration:1];
    SKAction *performSelector = [SKAction performSelector:@selector(addCreep) onTarget:self];
    SKAction *sequence = [SKAction sequence:@[performSelector, wait]];
    SKAction *repeat   = [SKAction repeatAction:sequence count:creepsOnWave ];
    [self runAction:repeat];
    
    currentWave++;
    if((currentWave%2)==0)
    {
        path = self.terrain.creepPath2;
    }
    else
    {
        path = self.terrain.creepPath;
    }
    
    NSLog(@"creep wave added");
}

-(void) addCreep{
    
    Creep *creep = [activeCreeps objectAtIndex: lastCreepIndex];
    
    lastCreepIndex++;
    
    [self addChild: creep];
    
    livingCreeps++;
    
    //ajusta o tamanho do sprite
    creep.xScale = 0.25;
    creep.yScale = 0.25;
    
    SKAction *followLine = [SKAction followPath:path asOffset:NO orientToPath:NO duration:creep.velocity];
    
    [creep runAction: followLine completion: ^{
        
        NSLog(@"creep has trespassed the line");
        [self discountHealth: creep];
    }];
}

-(void)addTowerIcons{
    
    NSArray *turretIconNames = @[@"tower2_icon",@"tower3_icon",@"tower4_icon"];

    int i = 2;
    for (NSString *turretIconName in turretIconNames) {
        
        SKSpriteNode *turretIconSprite = [SKSpriteNode spriteNodeWithImageNamed:turretIconName];
        
        [turretIconSprite setName:@"towerIcon"];
        //[turretIconSprite setColor:[SKColor blackColor]];
        //[turretIconSprite setColorBlendFactor:0.8];
        [turretIconSprite setPosition:CGPointMake(40+[turretIconNames indexOfObject:turretIconName]*65, 30)];
        
//        if( i==1){
//         
//            turretIconSprite.userData = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:90] forKey:@"cost"];
//            [turretIconSprite.userData setObject: [NSNumber numberWithInt:TowerOne] forKey:@"type"];
//            
//        }
        if ( i==2){
            turretIconSprite.userData = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:100] forKey:@"cost"];
            [turretIconSprite.userData setObject: [NSNumber numberWithInt:TowerTwo] forKey:@"type"];
        }
        else if (i==3){
            turretIconSprite.userData = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:110] forKey:@"cost"];
            [turretIconSprite.userData setObject: [NSNumber numberWithInt:TowerThree] forKey:@"type"];
        }
        else{
            turretIconSprite.userData = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:120] forKey:@"cost"];
            [turretIconSprite.userData setObject: [NSNumber numberWithInt:TowerFour] forKey:@"type"];
        }
        
        turretIconSprite.xScale = 0.08;
        turretIconSprite.yScale = 0.08;
        [self addChild:turretIconSprite];
        i++;
    }
}

-(void) gameOver{
    
    NSLog(@"Game Over");
    GameOver *gameOver = [GameOver sceneWithSize:self.frame.size];
    SKTransition *transition = [SKTransition crossFadeWithDuration:1.0];
    [self.view presentScene:gameOver transition:transition];
}

-(void) gameWin{
    
    NSLog(@"You Win");
    GameWin *gameWin = [GameWin sceneWithSize:self.frame.size];
    SKTransition *transition = [SKTransition crossFadeWithDuration:1.0];
    [self.view presentScene:gameWin transition:transition];
}


@end