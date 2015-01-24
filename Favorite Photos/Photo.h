//
//  Photo.h
//  Favorite Photos
//
//  Created by Diego Cichello on 1/22/15.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface Photo : NSObject<NSCoding>



@property NSString *photoUrl;
@property NSString *thumbnailURL;
@property NSString *tags;
@property NSData *photoImage;
@property NSDate * dateCreate;
@property NSString * user;
@property NSString * userPhoto;
@property NSNumber * likesNumber;
@property NSNumber * latitude;
@property NSNumber * longitude;
@property NSString * photoId;
@property BOOL isFavorited;




@end
    