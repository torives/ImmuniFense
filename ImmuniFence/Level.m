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

//TODO  implementar o ingame menu
//TODO  implementar a pausa do jogo.
//TODO  ainda não está se adicionando as waves subsequentes, tem que acertar a questão do tempo
//TODO  considerar o tempo de adição de cada creep da wave

/*Declaração dos métodos privados da classe*/
@interface Level ()

-(void) createHud;
-(void) addCreeps;
-(void) updateHealthIndicator;
-(void) updateCoinIndicator;
-(void) discountHealth: (Creep *) creep;
-(void) gameOver;
-(void) gameWin;

@end

@implementation Level{
    
    int health;
    int currentWave;
    int coins;
    LevelWave *levelOneWaves;
    NSMutableArray *towerSpots;
    NSMutableArray *activeCreeps;
    CGMutablePathRef path;
    NSTimeInterval timeOfLastMove;
    //cada wave define o tempo de espera para a próxima wave
    NSTimeInterval currentWaveCooldown;
    int lastCreepIndex;
}



//SKAction *wait = [SKAction waitForDuration:1];
//SKAction *performSelector = [SKAction performSelector:@selector(addCreeps) onTarget:self];
//SKAction *sequence = [SKAction sequence:@[performSelector, wait]];
//SKAction *repeat   = [SKAction repeatAction:sequence count:[levelOneWaves numberOfCreepsForWave: currentWave]];
//[self runAction: repeat];




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
    
    //se registra como delegate de contato para tratar das colisões
    lvl.physicsWorld.contactDelegate = lvl;
    
    return lvl;
}


-(void) didMoveToView:(SKView *)view{
    
    //define o mapa da fase
    Terrain *levelOneTerrain = [Terrain initWithLevel:LevelOne];
    SKSpriteNode* map = levelOneTerrain.map;
    map.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    map.yScale = 0.3;
    map.xScale = 0.3;
    [self addChild: map];
    
    coins = levelOneTerrain.coins;
    
    NSLog(@"terminou terreno");
    //cria o HUD do jogo
    [self createHud];
    
    //cria os placeholders para criar as torres
    towerSpots = levelOneTerrain.towerSpot;
    for ( NSValue *value in towerSpots) {
        
        //NSValue *getPoint = [towerSpots objectAtIndex:i];
        CGPoint towerSpot = [value CGPointValue];
        
        SKShapeNode *towerSpawnPoint = [SKShapeNode shapeNodeWithCircleOfRadius:75];
        towerSpawnPoint.hidden = YES;
        towerSpawnPoint.name = @"towerSpawnPoint";
        
        //TODO Pode dar merda pq a posição tem que ser de acordo com o sistema de coordenadas do pai. Conferir isso.
        towerSpawnPoint.position = towerSpot;
        //adiciona o spawn point ao mapa
        [map addChild:towerSpawnPoint];
    }
    
    //guarda o path pra usar com a velocidade diferente de cada creep
    path = levelOneTerrain.creepPath;
    
    //pega a referencia para as waves da fase
    levelOneWaves = [[LevelWave alloc]initWithLevel: LevelOne];
  
    //descobre o tempo de espera para chamar a próxima wave
    //currentWaveCooldown = [levelOneWaves cooldownForWave: currentWave];
    
    //inicializa o vetor de creeps ativas
    activeCreeps = [[NSMutableArray alloc] init];
    
    SKAction *wait = [SKAction waitForDuration: [levelOneWaves cooldownForWave: currentWave]];
    SKAction *performSelector = [SKAction performSelector:@selector(addCreepWave) onTarget:self];
    SKAction *sequence = [SKAction sequence:@[performSelector, wait]];
    SKAction *repeat   = [SKAction repeatAction:sequence count: levelOneWaves.numberOfWaves];
    [self runAction:repeat];
}


//IMPLEMENTAÇÃO INCOMPLETA
//A cada novo frame, confere se as torres possuem um alvo.
//Se possuirem, atira se tiver passado tempo o suficiente, de acordo com o seu fireRate
//TODO esse método tem que contar o tempo necessário para adicionar a próxima wave de creeps
-(void) update:(NSTimeInterval)currentTime{
    
    
    //Controla o tiro das torres
    [self enumerateChildNodesWithName:@"tower" usingBlock:^(SKNode *node, BOOL *stop) {
        
        Tower *tower = (Tower *) node;
        
        Creep *target = [tower.targets objectAtIndex:0];
        
        if (target.hitPoints <= 0) {
            
            [tower.targets removeObjectAtIndex:0];
        }
        else if (currentTime - timeOfLastMove >= tower.fireRate){
            //esse método simplesmente cria o projétil e o manda na direção do alvo,
            //removendo-o no contato. O dano e a morte do creep tem que ser tratados
            //nos métodos de SKPhysicsContactDelegate
            [tower shootAtTarget:target];
        }
    }];
    
    //atualiza o sprite dos creeps de acordo com a direção que eles seguem
    [self enumerateChildNodesWithName:@"creep" usingBlock:^(SKNode *node, BOOL *stop){
        
        Creep *creep = (Creep *) node;
        [creep updateAnimation];
    }];
    
    //timeOfLastMove = currentTime;
}

//-(void) didEvaluateActions{
//    NSLog(@"didevaluateactions");
//}

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
        
    }
    //se um projétil atingiu um creep, desconta o dano da torre
    else if (firstBody.categoryBitMask == CreepMask && secondBody.categoryBitMask == BulletMask) {
        
        Creep *creep = (Creep *) firstBody.node;
        Tower *tower = (Tower *) secondBody.node.parent;
        
        if (creep.hitPoints > 0) {
            //aplica o dano
            creep.hitPoints -= tower.damage;
            //se creep morreu
            if (creep.hitPoints <= 0) {
                
                //incrementa as coins
                coins += creep.reward;
                //atualiza o HUD
                [self updateCoinIndicator];
                //retira o creep da cena
                [creep removeFromParent];
                //retira o creep da relação de creeps vivos
                [activeCreeps removeObject: creep];
                
                //Se não há creeps ativos e acabaram as waves
                if (activeCreeps.count == 0 && currentWave == [levelOneWaves numberOfWaves]){
                    
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

//IMPLEMENTAÇÃO INCOMPLETA
-(void)selectNodeForTouch:(CGPoint)touchLocation{
    
    //    SKSpriteNode *touchedNode = (SKSpriteNode*)[self nodeAtPoint:touchLocation];
    //
    //    if ([touchedNode.name isEqualToString: @"towerSpawnPoint"]) {
    //
    //        Tower *newTower = [Tower createTowerOfType TowerOne];
    //        newTower.position = touchedNode.position;
    //
    //        [towerSpots removeObject:touchedNode];
    //
    //    }
    //    else if (touchedNode.name isEqualToString: @"tower"){
    //
    //    }
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
    healthIndicator.position = CGPointMake(10,CGRectGetMaxY(self.frame)-50);
    healthIndicator.anchorPoint = CGPointMake(0, 0);
    healthIndicator.name = @"healthIndicator";
    
    //Cria label de vida
    SKLabelNode *healthLabel = [SKLabelNode labelNodeWithFontNamed:@"Menlo-Regular"];
    healthLabel.text = [NSString stringWithFormat:@"%d", health];
    healthLabel.fontSize = 14;
    healthLabel.fontColor = [SKColor blackColor];
    healthLabel.position = CGPointMake(10+healthIndicator.frame.size.width/2, healthIndicator.frame.size.height/2);
    healthLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    healthLabel.name = @"healthLabel";
    
    //adiciona a label ao indicator
    [healthIndicator addChild:healthLabel];
    //adiciona o indicator a cena
    [self addChild: healthIndicator];
    
    //Cria o indicador de moedas
    SKSpriteNode *coinIndicator = [SKSpriteNode spriteNodeWithImageNamed:@"coin_hud"];
    coinIndicator.position = CGPointMake(130,CGRectGetMaxY(self.frame)-50);
    coinIndicator.anchorPoint = CGPointMake(0, 0);
    coinIndicator.name = @"coinIndicator";
    
    //Cria label de coins
    SKLabelNode *coinLabel = [SKLabelNode labelNodeWithFontNamed:@"Menlo-Regular"];
    coinLabel.text = [NSString stringWithFormat:@"%d", coins];
    coinLabel.fontSize = 14;
    coinLabel.fontColor = [SKColor blackColor];
    coinLabel.position = CGPointMake(10+coinIndicator.frame.size.width/2, coinIndicator.frame.size.height/2);
    coinLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    coinLabel.name = @"coinLabel";
    
    //adiciona a label ao indicador
    [coinIndicator addChild:coinLabel];
    //adiciona o indicador a cena
    [self addChild: coinIndicator];
}

//chamado quando um creep atravessa a linha de defesa.
//TODO no futuro, esse método deve penalizar o jogador caso muitos creeps ultrapassem.
//TODO conferir se é aqui mesmo que tem que liberar o CGMutablePath da memória
-(void)discountHealth: (Creep *) creep{
    
    //TODO tem que conferir se esse typecast aqui não vai dar merda
    health -= creep.damage;
    
    //Se a vida zerar, é Game Over
    //TODO o Game Over pode ser uma chamada de função
    if (health <= 0){
        
        [self gameOver];
    }
    
    //Atualiza o HUD
    [self updateHealthIndicator];
    //retira o creep da cena
    [creep removeFromParent];
    //retira o creep da relação de creeps vivos
    [activeCreeps removeObject: creep];
    
    //Se não há creeps ativos e acabaram as waves
    //TODO acho que tem que fazer essa conferencia no didKillEnemy também
    if (activeCreeps.count == 0 && currentWave == [levelOneWaves numberOfWaves]){
        
        //TODO game win
        [self gameWin];
    }
}

-(void) updateHealthIndicator{
    
    SKNode *healthIndicator = [self childNodeWithName:@"healthIndicator"];
    SKLabelNode *healthLabel = (SKLabelNode*)[healthIndicator childNodeWithName:@"healthLabel"];
    healthLabel.text = [NSString stringWithFormat:@"%d", health];
    NSLog(@"Health Updated");
}

-(void) updateCoinIndicator{
    
    SKNode *coinIndicator = [self childNodeWithName:@"coinIndicator"];
    SKLabelNode *coinLabel = (SKLabelNode*)[coinIndicator childNodeWithName:@"coinLabel"];
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
    NSLog(@"creep wave added");
}

-(void) addCreep{
    
    Creep *creep = [activeCreeps objectAtIndex: lastCreepIndex];
    
    lastCreepIndex++;
    
    [self addChild: creep];
    
    //ajusta o tamanho do sprite
    creep.xScale = 0.25;
    creep.yScale = 0.25;
    
    SKAction *followLine = [SKAction followPath:path asOffset:NO orientToPath:NO duration:creep.velocity];
    
    [creep runAction: followLine completion: ^{
        
        NSLog(@"creep has trespassed the line");
        [self discountHealth: creep];
    }];
}

-(void) gameOver{
    
    //    NSLog(@"Game Over");
    //    GameOver *gameOver = [GameOver sceneWithSize:self.frame.size];
    //    SKTransition *transition = [SKTransition crossFadeWithDuration:1.0];
    //    [self.view presentScene:gameOver transition:transition];
}

-(void) gameWin{
    
    //    NSLog(@"You Win");
    //    GameWin *gameWin = [GameWin sceneWithSize:self.frame.size];
    //    SKTransition *transition = [SKTransition crossFadeWithDuration:1.0];
    //    [self.view presentScene:gameWin transition:transition];
}

@end