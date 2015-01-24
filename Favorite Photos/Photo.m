//
//  Photo.m
//  Favorite Photos
//
//  Created by Diego Cichello on 1/22/15.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

#import "Photo.h"

@implementation Photo

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {




        self.thumbnailURL = [aDecoder decodeObjectForKey:@"thumbnail_url"];
        self.photoUrl = [aDecoder decodeObjectForKey:@"photo_URL"];
        self.tags = [aDecoder decodeObjectForKey:@"tags"];
        self.dateCreate = [aDecoder decodeObjectForKey:@"date_create"];
        self.user = [aDecoder decodeObjectForKey:@"user"];
        self.userPhoto = [aDecoder decodeObjectForKey:@"user_photo"];
        self.likesNumber = [aDecoder decodeObjectForKey:@"likes_number"];
        self.latitude = [aDecoder decodeObjectForKey:@"latitude"];
        self.longitude = [aDecoder decodeObjectForKey:@"longitude"];
        self.photoId = [aDecoder decodeObjectForKey:@"photo_id"];
        self.photoImage = [aDecoder decodeObjectForKey:@"photoImage"];

    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{




    [encoder encodeObject:self.photoUrl forKey:@"photo_URL"];
    [encoder encodeObject:self.thumbnailURL forKey:@"thumbnail_url"];
    [encoder encodeObject:self.tags forKey:@"tags"];
    [encoder encodeObject:self.dateCreate forKey:@"date_create"];
    [encoder encodeObject:self.user forKey:@"user"];
    [encoder encodeObject:self.userPhoto forKey:@"user_photo"];
    [encoder encodeObject:self.likesNumber forKey:@"likes_number"];
    [encoder encodeObject:self.latitude forKey:@"latitude"];
    [encoder encodeObject:self.longitude forKey:@"longitude"];
    [encoder encodeObject:self.photoId forKey:@"photo_id"];
    [encoder encodeObject:self.photoImage forKey:@"photoImage"];

}

@end
