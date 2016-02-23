//
//  CheckerCell.h
//  CheckerApp
//
//  Created by Jack Lor on 2/22/16.
//  Copyright © 2016 Jack Lor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckerCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UIView *piece;
@property (nonatomic, strong) IBOutlet UILabel *direction;

@end
