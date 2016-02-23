//
//  CheckerVC.h
//  CheckerApp
//
//  Created by Jack Lor on 2/22/16.
//  Copyright © 2016 Jack Lor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameManager.h"

@interface CheckerVC: UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>
{
    
}

@property (nonatomic, strong) GameManager *gameManager;

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;


@end

