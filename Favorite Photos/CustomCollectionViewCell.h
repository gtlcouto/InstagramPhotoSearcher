//
//  CustomCollectionViewCell.h
//  Favorite Photos
//
//  Created by Diego Cichello on 1/22/15.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"

@class CustomCollectionViewCell;

@protocol CustomCellDelegate <NSObject>



- (void) didTheFavoriteStarButtonBeingPressed:(NSIndexPath *)indexPath;

@end

@interface CustomCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
//@property (weak, nonatomic) IBOutlet UIButton *favouriteStar;
@property (weak, nonatomic) IBOutlet UIImageView *favouriteStar;
@property Photo *photo;
@property NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UIImageView *favoriteImageView;

@property BOOL isPictureFavourite;


@property (nonatomic,weak) id <CustomCellDelegate> delegate;
//- (void) changeStarColor;

@end
