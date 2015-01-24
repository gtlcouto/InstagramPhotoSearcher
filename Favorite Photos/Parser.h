//
//  Parser.h
//  MMFavPics
//
//  Created by Gustavo Couto on 2015-01-22.
//  Copyright (c) 2015 Gustavo Couto. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ParserDelegate <NSObject>

@optional
-(void)arrayLoadedWithPhoto:(NSMutableArray *)photoArray;

@end

@interface Parser : NSObject

@property (nonatomic, weak) id<ParserDelegate>delegate;

-(void)getDataFromInstagramApiByString:(NSString *)searchString;

@end
