//
//  FavoritesViewController.m
//  Favorite Photos
//
//  Created by Diego Cichello on 1/22/15.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

#import "FavoritesViewController.h"
#import "CustomCollectionViewCell.h"
#import "MapViewController.h"
#import "Photo.h"

@interface FavoritesViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property Photo *photoSwipped;

@end

@implementation FavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];

    Photo *photo = [self.favoritesArray objectAtIndex:indexPath.row];



    cell.favoriteImageView.image = [UIImage imageWithData:photo.photoImage];


    return cell;
}



- (IBAction)swipeHandler:(UISwipeGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];

    self.photoSwipped = [self.favoritesArray objectAtIndex:indexPath.row];

    UIAlertView *alertView = [UIAlertView new];
    alertView.delegate = self;
    alertView.title = @"Delete";
    alertView.message =@"Do you want to delete this photo?";
    [alertView addButtonWithTitle:@"No!"];
    [alertView addButtonWithTitle:@"Yes"];
    [alertView show];



}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self removePhotoFromFavorites:self.photoSwipped];
        [self.collectionView reloadData];
    }
}

- (void)removePhotoFromFavorites: (Photo *)photo
{

    for (Photo *currentPhoto in self.favoritesArray)
    {
        if ([photo.photoId isEqualToString:currentPhoto.photoId])
        {
            photo.isFavorited = false;
            [self.favoritesArray removeObject:currentPhoto];
            
            break;
        }

    }
    
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MapViewController *mapVC = segue.destinationViewController;
    mapVC.favoritePhotos = self.favoritesArray;

}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.favoritesArray.count;
}




@end
