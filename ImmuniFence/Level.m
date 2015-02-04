//
//  Level1.m
//  ImmuniFense
//
//  Created by Victor Yves Crispim on 02/5/15.
//  Copyright (c) 2015 Group 9. All rights reserved.
//

#import "Level.h"
#import "BitMasks.h"

//CLASSES AINDA NÃO IMPLEMENTADAS
//#import "Wave.h"
//#import "Terrain.h"
//#import "Creep.h"
//#import "Tower.h"

//TODO  implementar o ingame menu
//TODO  implementar a pausa do jogo.
//TODO  ainda não está se adicionando as waves subsequentes, tem que acertar a questão do tempo
//TODO  configurar o método de inicialização para deixar a classe Level genérica
//TODO  inicializar coins com o terreno

/*Declaração dos métodos privados da classe*/
@interface Level ()

    -(void) createHUD;
    -(void) addCreeps;
    -(void) updateHealthIndicator;
    -(void) updateCoinsIndicator;
    -(void) discountHealth: (SKSpriteNode *) creep;
    -(void) gameOver;
    -(void) gameWin;

@end

@implementation Level{
    
    int coins;
    int health;
    int actualWave;
    LevelWaves *levelOneWaves;
    NSMutableArray *towerSpots;
    NSMutableArray *activeCreeps;
    SKAction *followLine;
    NSTimeInterval timeOfLastMove;
}

/*****************************
*
*  Métodos de SKScene
*
***/

-(void) didMoveToView:(SKView *)view{
      
    //inicializa as variáveis da fase
    coins = 90;
    health = 20;
    actualWave = 0;

    //se registra como delegate de contato para tratar das colisões
    self.physicsWorld.contactDelegate = self;

    //define o mapa da fase
    Terrain *levelOneTerrain = [Terrain terrainForLevel: LevelOne];
    SKSpriteNode* map = levelOneTerrain.map;
    map.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild: map];

    //cria o HUD do jogo
    [self createHUD];

    //cria os placeholders para criar as torres
    //TODO conferir se esse enhanced for vai funfar
    towerSpots = levelOneTerrain.towerSpots;
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

    //cria a ação para percorrer o caminho
    //TODO no futuro, usar a chamada do método com velocity ou invés de duration
    followLine = [SKAction followPath: levelOneTerrain.path asOffset:NO orientToPath:YES duration:50];

    //pega a referencia para as waves da fase
    levelOneWaves = [LevelWaves waveForLevel: LevelOne];
    //inicializa o vetor de creeps ativas
    activeCreeps = [[NSMutableArray alloc] init];
    //adiciona as creeps da próxima wave no vetor de creeps ativas
    [self addCreeps];
}


//IMPLEMENTAÇÃO INCOMPLETA
//A cada novo frame, confere se as torres possuem um alvo. Se sim, atira.
//TODO esse método tem que contar o tempo necessário para adicionar a próxima wave de creeps
-(void) update:(NSTimeInterval)currentTime{

    //TODO 0.5 é o tempo de tiro da torre. Tem que mudar isso, cada torre com uma velocidade.
    //Se estiver com problema, pode ser a sintaxe dessa merda. Aí é só copiar do DEMO.
    if (currentTime - timeOfLastMove >= 0.5){
    
        [self enumerateChildNodesWithName:@"tower" usingBlock:^(SKNode *node, BOOL *stop) {
          
            Tower *tower = (Tower *) node;

            CreepNode *target = [tower.targets objectAtIndex:0];
            
            if (target.health <= 0) {
            
                [tower.targets removeObjectAtIndex:0];
            }
            else {
                //esse método simplesmente cria o projétil e o manda na direção do alvo,
                //removendo-o no contato. O dano e a morte do creep tem que ser tratados
                //nos métodos de SKPhysicsContactDelegate
                [tower shootAtTarget:target];
            }
        }];
        
        timeOfLastMove = currentTime;
    }
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
        
    }
    //se um projétil atingiu um creep, desconta o dano da torre
    else if (firstBody.categoryBitMask == CreepMask && secondBody.categoryBitMask == BulletMask) {
        
        Creep *creep = (Creep *) firstBody.node;
        Tower *tower = (Tower *) secondBody.node.parent;
        
        if (creep.health > 0) {
            //aplica o dano
            creep.health -= tower.damage;
            //se creep morreu
            if (creep.health <= 0) {
                
                //incrementa as coins
                coins += creep.reward;
                //atualiza o HUD
                [self updateCoinsIndicator];
                //retira o creep da cena
                [creep removeFromParent];
                //retira o creep da relação de creeps vivos
                [activeCreeps removeObject: creep];
                 
                //Se não há creeps ativos e acabaram as waves
                if (activeCreeps.count == 0 && actualWave == [levelOneWaves numberOfWaves]){
                     
                    [self gameWin];
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
    healthIndicator.name = @"health_hud";
    
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
    coinIndicator.name = @"coin_hud";
    
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
-(void)discountHealth: (SKSpriteNode *) creep{
    
    //TODO tem que conferir se esse typecast aqui não vai dar merda
    health -= (Creep *)creep.damage;
    
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
    if (activeCreeps.count == 0 && actualWave == [levelOneWaves numberOfWaves]){
        
        //TODO game win
        [self gameWin];
    }
}

-(void) updateHealthIndicator{
    
    SKLabelNode *healthLabel = (SKLabelNode*)[self childNodeWithName:@"healthLabel"];
    healthLabel.text = [NSString stringWithFormat:@"%d", health];
    NSLog(@"Health Updated");
}

-(void) updateCoinsIndicator{
    
    SKLabelNode *coinsLabel = (SKLabelNode*)[self childNodeWithName:@"coinLabel"];
    coinsLabel.text = [NSString stringWithFormat:@"%d", coins];
    NSLog(@"Coins Updated");
}

//adiciona as creeps da próxima wave no vetor de creeps ativas. Deve ser chamada dentro de um intervalo de tempo definido
-(void) addCreeps{
    
    if (actualWave < [levelOneWaves numberOfWaves]) {
        
        NSUInteger lastCreepIndex = [activeCreeps indexOfObject:[activeCreeps lastObject]];
        
        //instancia os creeps da primeira wave e os guarda no vetor de creeps
        [activeCreeps addObjectsFromArray:[levelOneWaves createCreepsForWave: actualWave]];
        
        //para cada creep no array de creeps ativas, coloca pra seguir o caminho
        //OBS: quando vc manda as creeps seguirem um path, elas não precisam de uma position. Começam na inicial do path
        for (lastCreepIndex++;lastCreepIndex < activeCreeps.count; lastCreepIndex++) {
            
            SKSpriteNode *creep = (SKSpriteNode *) [activeCreeps objectAtIndex: lastCreepIndex];
            
            [self addChild: creep];
            
            [creep runAction: followLine completion: ^{
                
                NSLog(@"Creep has trespassed the line");
                [self discountHealth: creep]; //se eu entendi Blocks direito, ele vai manter a referencia para o creep.
            }];
        }
        //incrementa o contador de waves
        actualWave++;
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