//
//  CustomAnnotation.h
//  Favorite Photos
//
//  Created by Diego Cichello on 1/23/15.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "Photo.h"

@interface CustomAnnotation : MKPointAnnotation

@property Photo *photo;

@end
