//
//  ViewController.m
//  Favorite Photos
//
//  Created by Diego Cichello on 1/22/15.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

#import "RootViewController.h"
#import "CustomCollectionViewCell.h"
#import "FavoritesViewController.h"
#import "Parser.h"
#import "Photo.h"



#define kDateKey @"dateKey"

@interface RootViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UISearchBarDelegate,ParserDelegate>

@property NSMutableArray *favouritePhotos;
@property NSMutableArray *instagramPhotos;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property Parser *parser;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.favouritePhotos = [NSMutableArray new];
    self.parser = [Parser new];
    self.parser.delegate = self;
    [self load];

    if ([self connected])
    {
        [self.parser getDataFromInstagramApiByString:@"BellaMasumoto"];
    }
    else
    {
        UIAlertView *alertview = [UIAlertView new];
        alertview.title = @"Network Problem";
        alertview.message = @"No internet connection";
        [alertview addButtonWithTitle:@"OK"];
        [alertview show];
    }

}

- (void) viewWillAppear:(BOOL)animated
{
    [self.collectionView reloadData];
}

- (BOOL)connected
{
    NSString *URLString = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"]];
    BOOL result;
    result = ( URLString != NULL ) ? YES: NO;

    return result;

}

-(void)arrayLoadedWithPhoto:(NSMutableArray *)photoArray
{
    self.instagramPhotos = photoArray;
    [self.collectionView reloadData];

    if (!self.favouritePhotos)
    {
        self.favouritePhotos = [NSMutableArray new];
    }

    for (Photo *photo in self.favouritePhotos)
    {
        for (Photo *photoOfInstagram in self.instagramPhotos)
        {
            if ([photoOfInstagram.photoId isEqual:photo.photoId])
            {
                photoOfInstagram.isFavorited = YES;
            }
        }
    }
}



- (IBAction)didStarImagePressed:(UITapGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];

    Photo *photo =[self.instagramPhotos objectAtIndex:indexPath.row];

    if (photo.isFavorited)
    {

        [self removePhotoFromFavorites:photo];
        photo.isFavorited = false;

    }
    else
    {

        [self.favouritePhotos addObject:photo];
        photo.isFavorited = true;
    }

    [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
    [self save];

}

- (void)removePhotoFromFavorites: (Photo *)photo
{

    for (Photo *currentPhoto in self.favouritePhotos)
    {
        if ([photo.photoId isEqualToString:currentPhoto.photoId])
        {
            [self.favouritePhotos removeObject:currentPhoto];
            break;
        }

    }


}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.parser getDataFromInstagramApiByString:searchBar.text];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Item" forIndexPath:indexPath];

    Photo *photo = [self.instagramPhotos objectAtIndex:indexPath.row];


    if (photo.isFavorited)
    {
        cell.favouriteStar.image = [UIImage imageNamed:@"favoriteClicked"];
    }
    else
    {
        cell.favouriteStar.image = [UIImage imageNamed:@"favoriteBlank"];
    }
    cell.imageView.image = [UIImage imageWithData:photo.photoImage];

    cell.indexPath = indexPath;
    cell.photo = photo;
    

    return cell;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.instagramPhotos.count;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    FavoritesViewController *favoritesVC = segue.destinationViewController;
    favoritesVC.favoritesArray = self.favouritePhotos;
}

-(NSURL *)documentsDirectory
{
    return [[NSFileManager defaultManager]URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
}

- (NSURL *)pList
{
    NSURL *pListPath = [[self documentsDirectory] URLByAppendingPathComponent:@"favorites.bin"];
    return pListPath;
}

- (void) save
{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSURL *pListPath;
    pListPath = [self pList];

    NSData *favoritesData = [NSKeyedArchiver archivedDataWithRootObject:self.favouritePhotos];
    [favoritesData writeToURL:pListPath atomically:YES];

    //[s writeToURL:pListPath atomically:NO];
    [defaults setObject:[NSDate date] forKey:kDateKey];
    [defaults synchronize];
}

- (void) load
{
    NSURL *pListPath;
    pListPath = [self pList];

    NSData *favoritesData = [NSData dataWithContentsOfURL:pListPath];
    self.favouritePhotos = [NSKeyedUnarchiver unarchiveObjectWithData:favoritesData];




}


- (void) searchPopularPhotos
{
    NSURL *url = [NSURL URLWithString:@"https://api.instagram.com/v1/media/popular?access_token=210546517.cae98ea.fd343550be5f4901b49267147884f0a7"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    self.instagramPhotos = [jsonDictionary objectForKey:@"data"];


    }];
}







































@end
