/*
  ViewController.m
  Favorite Photos

  Created by Diego Cichello on 1/22/15.
  Copyright (c) 2015 Mobile Makers. All rights reserved.

  REVISIONS: Gustavo Couto 1/22/15 6:58
             -Fixed search bar crashing when spaces were present
             -Added twitter button implementations
*/

#import "RootViewController.h"
#import "CustomCollectionViewCell.h"
#import "MapViewController.h"
#import "Parser.h"
#import "Photo.h"
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>



#define kDateKey @"dateKey"

@interface RootViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UISearchBarDelegate,ParserDelegate,UIScrollViewDelegate, MFMailComposeViewControllerDelegate>

@property NSMutableArray *favouritePhotos;
@property NSMutableArray *currentPhotos;

@property MFMailComposeViewController * mc;
@property NSMutableArray *draggedCells;
@property BOOL isSearchBarVisible;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property Parser *parser;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraintSearchBar;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.favouritePhotos = [NSMutableArray new];
    self.draggedCells = [NSMutableArray new];
    self.parser = [Parser new];
    self.parser.delegate = self;
    self.mc = [[MFMailComposeViewController alloc] init];
    [self load];

    self.topConstraintSearchBar.constant = -50;

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
- (IBAction)searchButtonTapped:(UIButton *)sende
{
    if(self.isSearchBarVisible)
    {

    [UIView animateWithDuration:0.2 animations:^{
        self.topConstraintSearchBar.constant = 0;
        [self.view layoutIfNeeded];
    }];
    }
    else
    {
        [UIView animateWithDuration:0.2 animations:^{
            self.topConstraintSearchBar.constant = -50;
            [self.view layoutIfNeeded];
        }];
    }
    self.isSearchBarVisible = !self.isSearchBarVisible;

}


- (void)cellAnimationToLeft:(CustomCollectionViewCell *)cell
{
    [UIView animateWithDuration:0.2 animations:^{
        cell.leftConstraint.constant = -8;
        cell.rightConstraint.constant = -8;

        [cell.imageView layoutIfNeeded];
    }];
}
- (IBAction)onFavoriteButtonPressed:(UIButton *)sender
{
    self.currentPhotos = self.favouritePhotos;
    [self.collectionView reloadData];

    
}

-(IBAction)onSwipe:(UISwipeGestureRecognizer *)swipeGesture
{
    CGPoint point = [swipeGesture locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
    CustomCollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];

    if (swipeGesture.direction == UISwipeGestureRecognizerDirectionRight)
    {

        for (CustomCollectionViewCell *cell in self.draggedCells)
        {
            [self cellAnimationToLeft:cell];
            [self.draggedCells removeObject:[self.draggedCells lastObject]];
            
        }

        [UIView animateWithDuration:0.2 animations:^{
            cell.leftConstraint.constant = 72;
            cell.rightConstraint.constant = -88;
            [self.draggedCells addObject:cell];
            [cell.imageView layoutIfNeeded];
        }];
    }
    else if (swipeGesture.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        [self cellAnimationToLeft:cell];
        [self.draggedCells removeObject:cell];
    }

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    for (CustomCollectionViewCell *cell in self.draggedCells)
    {
        [self cellAnimationToLeft:cell];

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
    self.currentPhotos = photoArray;
    [self.collectionView reloadData];

    if (!self.favouritePhotos)
    {
        self.favouritePhotos = [NSMutableArray new];
    }

    for (Photo *photo in self.favouritePhotos)
    {
        for (Photo *photoOfInstagram in self.currentPhotos)
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

    Photo *photo =[self.currentPhotos objectAtIndex:indexPath.row];

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
    NSString * str = searchBar.text;
    str=[str stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self.parser getDataFromInstagramApiByString:str];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Item" forIndexPath:indexPath];

    Photo *photo = [self.currentPhotos objectAtIndex:indexPath.row];


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
    return self.currentPhotos.count;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MapViewController *mapVC = segue.destinationViewController;
    mapVC.favoritePhotos = self.favouritePhotos;
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
    self.currentPhotos = [jsonDictionary objectForKey:@"data"];


    }];
}

#pragma mark IBActions


- (IBAction)onButtonTwitterPressed:(id)sender {

    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"Twitter API Test"];
        CustomCollectionViewCell * cell = [self.draggedCells lastObject];
        [tweetSheet addImage:cell.imageView.image];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }

}

- (IBAction)onButtonEmailPressed:(id)sender {

    // Email Subject
    NSString *emailTitle = @"Check out this picture!";
    // Email Content
    NSString *messageBody = @"<h1>Check out this instagram picture!</h1>"; // Change the message body to HTML
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"check@out.com"];
     CustomCollectionViewCell * cell = [self.draggedCells lastObject];
    NSData * jpegData = UIImageJPEGRepresentation(cell.imageView.image, 1);
    NSString *fileName = @"picture";
    fileName = [fileName stringByAppendingPathExtension:@"jpeg"];

    [self.mc addAttachmentData:jpegData mimeType:@"image/png" fileName:fileName];
    self.mc.mailComposeDelegate = self;
    [self.mc setSubject:emailTitle];
    [self.mc setMessageBody:messageBody isHTML:YES];
    [self.mc setToRecipients:toRecipents];
    // Present mail view controller on screen
    [self presentViewController:self.mc animated:YES completion:NULL];
}









































@end
