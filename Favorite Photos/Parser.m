//
//  Parser.m
//  Favorite Photos
//
//  Created by Diego Cichello on 1/22/15.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

//  Parser.m
//  MMFavPics
//
//  Created by Gustavo Couto on 2015-01-22.
//  Copyright (c) 2015 Gustavo Couto. All rights reserved.
//

#import "Parser.h"
#import "Photo.h"

@implementation Parser


-(void)getDataFromInstagramApiByString:(NSString *)searchString
{

    NSMutableArray * photoArray = [[NSMutableArray alloc] init];
    //create connection using public
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?access_token=210546517.cae98ea.fd343550be5f4901b49267147884f0a7&count=5", searchString]];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        NSDictionary * jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSArray * jsonArray = [jsonDictionary objectForKey:@"data"];
        for (NSDictionary * jsonData in jsonArray )
        {
            

            Photo * photo = [[Photo alloc] init];
            photo.photoId = jsonData[@"id"];
            photo.tags = jsonData[@"tags"];
            photo.dateCreate = jsonData[@"created_time"];
            NSString * value = [jsonData objectForKey:@"location"];
            if (![value isKindOfClass:[NSNull class]])
            {
                NSDictionary * locationDictionary = jsonData[@"location"];
                photo.latitude =  locationDictionary[@"latitude"];
                photo.longitude = locationDictionary[@"longitude"];
            }
            NSDictionary * likesDictionary = jsonData[@"likes"];
            photo.likesNumber = likesDictionary[@"count"];
            NSDictionary * imagesDictionary = jsonData[@"images"];
            NSDictionary * thumbnailDictionary = imagesDictionary[@"thumbnail"];
            NSDictionary * standardImageDictionary = imagesDictionary[@"standard_resolution"];
            photo.photoUrl = [NSURL URLWithString:standardImageDictionary[@"url"]];
            photo.photoImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:standardImageDictionary[@"url"]]];
            photo.thumbnailURL = thumbnailDictionary[@"url"];
            NSDictionary * userDictionary = jsonData[@"user"];
            photo.user = userDictionary[@"username"];
            photo.userPhoto = userDictionary[@"profile_picture"];


            [photoArray addObject:photo];

        }
        [self.delegate arrayLoadedWithPhoto:photoArray];
        
    }];
}

@end
