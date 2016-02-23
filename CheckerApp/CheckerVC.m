//
//  CheckerVC.m
//  CheckerApp
//
//  Created by Jack Lor on 2/22/16.
//  Copyright © 2016 Jack Lor. All rights reserved.
//

#import "CheckerVC.h"
#import "CheckerCell.h"
#import "Pion.h"



#define ColorTileClear [UIColor colorWithRed:248.0/255.0 green:207.0/255.0 blue:84.0/255.0 alpha:1.0]
#define ColorTileDark [UIColor colorWithRed:167.0/255.0 green:110.0/255.0 blue:55.0/255.0 alpha:1.0]
#define ColorPionBlack [UIColor blackColor]
#define ColorPionWhite [UIColor whiteColor]


@interface CheckerVC ()

@end

@implementation CheckerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.gameManager = [GameManager sharedInstance];
    self.gameManager.gameView = self.collectionView;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - collectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return CHECKER_SIZE;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return CHECKER_SIZE;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    const CGSize size = CGSizeMake((self.collectionView.frame.size.width - 20.0) / 8.0, (self.collectionView.frame.size.height - 20.0) / 8.0);
    return size;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CheckerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"checkerCell" forIndexPath:indexPath];
    //set tile background color
    
    if ((indexPath.section % 2 == 0 && indexPath.row % 2 == 0) ||
        (indexPath.section % 2 != 0 && indexPath.row % 2 != 0))
        cell.backgroundColor = ColorTileClear;
    else
        cell.backgroundColor = ColorTileDark;
    
    //set pion
    id content = self.gameManager.checkerContent[indexPath.section][indexPath.row];
    if (content != [NSNull null])
    {
        Pion *pion = content;
        [cell.piece setHidden:NO];
        if (pion.pionColor == 0)
        {
            cell.piece.backgroundColor = ColorPionBlack;
            cell.direction.textColor = ColorPionWhite;
        }
        else
        {
            cell.piece.backgroundColor = ColorPionWhite;
            cell.direction.textColor = ColorPionBlack;
        }
        if (pion.goingDown == -1)
            cell.direction.text = @"↑";
        else if (pion.goingDown == 1)
            cell.direction.text = @"↓";
        [cell.direction setHidden:!pion.showDirection];
    
    }
    else
        [cell.piece setHidden:YES];
    //set available play
    for (NSIndexPath *indexPlay in self.gameManager.availablePlay)
    {
        if (indexPlay.section == indexPath.section && indexPlay.row == indexPath.row)
        {
            cell.piece.backgroundColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.5];
            [cell.piece setHidden:NO];
            [cell.direction setHidden:YES];
        }
    }
    if (self.gameManager.selectedPion && self.gameManager.selectedPion.row == indexPath.row && self.gameManager.selectedPion.section == indexPath.section)
    {
        cell.piece.layer.borderWidth = 2.0;
        cell.piece.layer.borderColor = [UIColor greenColor].CGColor;
    }
    else
        cell.piece.layer.borderWidth = 0.0;
    for (NSIndexPath *jumpPion in self.gameManager.jumpOption)
    {
        if (jumpPion.section == indexPath.section && jumpPion.row == indexPath.row)
        {
            cell.piece.layer.borderWidth = 2.0;
            cell.piece.layer.borderColor = [UIColor redColor].CGColor;
        }
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.gameManager.availablePlay.count > 0)
    {
        for (NSIndexPath *indexPlay in self.gameManager.availablePlay)
        {
            if (indexPlay.section == indexPath.section && indexPlay.row == indexPath.row)
            {
                [self.gameManager movePion:indexPath];
                return;
            }
        }
    }
    
    id content = self.gameManager.checkerContent[indexPath.section][indexPath.row];
    if (content != [NSNull null])
    {
        Pion *pion = content;
        if (pion.pionColor == self.gameManager.playerTurn && self.gameManager.jumpOption.count == 0)
        {
            self.gameManager.selectedPion = indexPath;
            [self.gameManager createAvailablePlay:indexPath jumped:NO];
            [self.collectionView reloadData];
        }
    }
}

#pragma mark - action

- (IBAction)restartGame:(id)sender
{
    self.gameManager = [[GameManager sharedInstance] init];
    [self.collectionView reloadData];
}

@end
