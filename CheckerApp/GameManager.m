//
//  GameManager.m
//  CheckerApp
//
//  Created by Jack Lor on 2/22/16.
//  Copyright © 2016 Jack Lor. All rights reserved.
//

#import "GameManager.h"
#import "Pion.h"

@implementation GameManager

static GameManager *sharedInstance = nil;

+ (GameManager *)sharedInstance {
    if (nil != sharedInstance) {
        return sharedInstance;
    }
    
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedInstance = [GameManager new];
    });
    
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        //create an empty board
        self.checkerContent = [NSMutableArray array];
        self.availablePlay = [NSMutableArray arrayWithCapacity:2];
        self.jumpOption = [NSMutableArray arrayWithCapacity:2];
        for (int y = 0; y < 8; y++)
        {
            [self.checkerContent addObject:[NSMutableArray array]];
            NSMutableArray *arrayLine = self.checkerContent[y];
            for (int x = 0; x < 8; x++)
                [arrayLine addObject:[NSNull null]];
        }
        //add black pions
        for (int y = 0; y < 3; y++)
        {
            for (int x = 1 - y % 2; x < CHECKER_SIZE; x+=2)
            {
                Pion *blackPion = [Pion new];
                blackPion.pionColor = 0;
                blackPion.goingDown = 1;
                [self.checkerContent[y] replaceObjectAtIndex:x withObject:blackPion];
            }
        }
        //add white pions
        for (int y = CHECKER_SIZE - 1; y > CHECKER_SIZE - 4; y--)
        {
            for (int x = 1 - y % 2; x < CHECKER_SIZE; x+=2)
            {
                Pion *whitePion = [Pion new];
                whitePion.pionColor = 1;
                whitePion.goingDown = -1;
                [self.checkerContent[y] replaceObjectAtIndex:x withObject:whitePion];
            }
        }
        self.playerTurn = 1;
    }
    self.AIPlayer = [AIPlayer new];
    self.AIPlayer.gameManager = self;
    self.AIPlayer.playerNumber = 0;
    return self;
}

- (void)createAvailablePlay:(NSIndexPath *)indexPath jumped:(BOOL)jumped
{
    NSInteger y = indexPath.section;
    NSInteger x = indexPath.row;
    [self.availablePlay removeAllObjects];
    [self.jumpOption removeAllObjects];
    id content = self.checkerContent[y][x];
    if (content != [NSNull null])
    {
        Pion *pion = content;
        //check diagonal left
        if (x > 0)
        {
            content = self.checkerContent[y + pion.goingDown][x - 1];
            if (content == [NSNull null] && jumped == NO)
                [self.availablePlay addObject:[NSIndexPath indexPathForRow:x - 1 inSection:y + pion.goingDown]];
            else if (content != [NSNull null] && x > 1)
            {
                Pion *nextPion = content;
                if (nextPion.pionColor != pion.pionColor && self.checkerContent[y + pion.goingDown * 2][x - 2] == [NSNull null])
                {
                    [self.jumpOption addObject:[NSIndexPath indexPathForRow:x - 1 inSection:y + pion.goingDown]];
                    [self.availablePlay addObject:[NSIndexPath indexPathForRow:x - 2 inSection:y + pion.goingDown * 2]];
                }
            }
        }
        //check diagonal right
        if (x < CHECKER_SIZE - 1)
        {
            content = self.checkerContent[y + pion.goingDown][x + 1];
            if (content == [NSNull null] && jumped == NO && self.jumpOption.count == 0)
                [self.availablePlay addObject:[NSIndexPath indexPathForRow:x + 1 inSection:y + pion.goingDown]];
            else if (content != [NSNull null] && x < CHECKER_SIZE - 2)
            {
                Pion *nextPion = content;
                if (nextPion.pionColor != pion.pionColor && self.checkerContent[y + pion.goingDown * 2][x + 2] == [NSNull null])
                {
                    if (self.jumpOption.count == 0)
                        [self.availablePlay removeAllObjects];
                    [self.jumpOption addObject:[NSIndexPath indexPathForRow:x + 1 inSection:y + pion.goingDown]];
                    [self.availablePlay addObject:[NSIndexPath indexPathForRow:x + 2 inSection:y + pion.goingDown * 2]];
                }
            }
        }
    }
}

- (void)movePion:(NSIndexPath *)indexPath
{
    Pion *pion = self.checkerContent[self.selectedPion.section][self.selectedPion.row];
    [self.checkerContent[self.selectedPion.section] replaceObjectAtIndex:self.selectedPion.row withObject:[NSNull null]];
    [self.checkerContent[indexPath.section] replaceObjectAtIndex:indexPath.row withObject:pion];
    
    NSLog(@"move pion %ld,%ld to %ld, %ld", (long)self.selectedPion.row, (long)self.selectedPion.section, (long)indexPath.row, (long)indexPath.section);
    if (pion.goingDown == 1 && indexPath.section == CHECKER_SIZE - 1)
    {
        pion.showDirection = YES;
        pion.goingDown = -1;
    }
    else if (pion.goingDown == -1 && indexPath.section == 0)
    {
        pion.showDirection = YES;
        pion.goingDown = 1;
    }
    
    if (self.jumpOption.count > 0)
    {
        NSInteger index = [self.availablePlay indexOfObject:indexPath];
        NSIndexPath *jumpPath = self.jumpOption[index];
        
        [self.checkerContent[jumpPath.section] replaceObjectAtIndex:jumpPath.row withObject:[NSNull null]];
        [self createAvailablePlay:indexPath jumped:YES];
        self.selectedPion = indexPath;
    }
    else
    {
        [self.availablePlay removeAllObjects];
        self.selectedPion = nil;
    }
    [self.gameView reloadData];
    if (self.jumpOption.count == 0)
    {
        if (self.playerTurn == 0)
            self.playerTurn = 1;
        else
        {
            self.playerTurn = 0;
            if (self.AIPlayer && self.AIPlayer.playerNumber == self.playerTurn)
            {
                [self.AIPlayer performSelector:@selector(playTurn) withObject:nil afterDelay:0.5];
            }
        }
        [self boardCheck];
    }
    else if (self.AIPlayer && self.AIPlayer.playerNumber == self.playerTurn)
    {
        [self.AIPlayer performSelector:@selector(playTurn) withObject:nil afterDelay:0.5];
    }
}

- (void)boardCheck
{
    self.selectedPion = nil;
    int whiteCount = 0;
    int blackCount = 0;
    for (int y = 0; y < CHECKER_SIZE; y++)
    {
        for (int x = 0; x < CHECKER_SIZE; x++)
        {
            id content = self.checkerContent[y][x];
            if (content != [NSNull null])
            {
                Pion *pion = content;
                //forcing player to do a jump move in case it happens
                if (pion.pionColor == 0)
                    blackCount++;
                else if (pion.pionColor == 1)
                    whiteCount++;
                if (pion.pionColor == self.playerTurn)
                {
                    NSIndexPath *currentPath = [NSIndexPath indexPathForRow:x inSection:y];
                    if (self.jumpOption.count == 0)
                        [self createAvailablePlay:currentPath jumped:YES];
                    if (self.jumpOption.count > 0 && self.selectedPion == nil)
                        self.selectedPion = currentPath;
                    else if (self.jumpOption.count == 0 && self.selectedPion == nil)
                        [self.availablePlay removeAllObjects];
                    
                }
            }
        }
    }
    if (blackCount == 0 || whiteCount == 0)
        self.playerTurn = -1;
}

@end
