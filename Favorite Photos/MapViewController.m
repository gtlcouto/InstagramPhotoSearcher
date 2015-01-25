//
//  MapViewController.m
//  Favorite Photos
//
//  Created by Diego Cichello on 1/23/15.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "Photo.h"
#import "CustomAnnotation.h"


@interface MapViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property Photo *currentPhoto;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate =self;
    [self insertAllFavoritePhotosLocation];

}

- (void) viewWillAppear:(BOOL)animated
{
    [self.mapView showAnnotations:self.mapView.annotations animated:true];
}


- (void) insertAllFavoritePhotosLocation
{
    for (Photo *photo in self.favoritePhotos)
    {
        [self addPinOnMapWithPhoto:photo];
    }

    
}

- (void) addPinOnMapWithPhoto:(Photo *)photo
{
    CustomAnnotation *point = [CustomAnnotation new];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([photo.latitude floatValue],[photo.longitude floatValue]);
    point.coordinate = coordinate;
    point.title = photo.user;
    point.photo = photo;
    
    [self.mapView addAnnotation:point];
}



- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    CustomAnnotation *customAnnotation = annotation;
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];



    pin.image = [self resizeImage:[UIImage imageWithData:customAnnotation.photo.photoImage] imageSize:CGSizeMake(40, 40)];

    pin.canShowCallout = YES;

    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];


    return pin;



}

-(UIImage*)resizeImage:(UIImage *)image imageSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0,size.width,size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    return newImage;
    
}
@end
