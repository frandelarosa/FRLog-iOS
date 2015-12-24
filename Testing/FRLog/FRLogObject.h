//
//  FRLogObject.h
//  FRLog iOS
//
//  Created by Francisco de la Rosa on 17/01/15.
//  Copyright (c) 2015 Fran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FRLogTypes.h"

@interface FRLogObject : NSObject

@property (nonatomic, assign) FRLogType type;
@property (nonatomic, strong) NSString *classname;
@property (nonatomic, strong) NSString *line;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *date;


@end
