//
//  FRLogURL.h
//  FRLog iOS
//
//  Created by Francisco de la Rosa on 17/01/15.
//  Copyright (c) 2015 Fran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FRLogObject.h"

@interface FRLogURL : FRLogObject

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *requestName;
@property (nonatomic, strong) NSString *statusCode;
@property (nonatomic, strong) NSString *timeresponse;

@end
