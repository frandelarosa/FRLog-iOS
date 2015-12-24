//
//  FRLogObject.m
//  FRLog iOS
//
//  Created by Francisco de la Rosa on 17/01/15.
//  Copyright (c) 2015 Fran. All rights reserved.
//

#import "FRLogObject.h"

@implementation FRLogObject

- (instancetype)init {
    
    self = [super init];
    
    if (self){
        
        self.date = [self getCurrentTime];
        
    }
    
    return self;
    
    
}

- (NSString *)getCurrentTime {
    
    // Get current datetime
    NSDate *currentDateTime = [NSDate date];
    
    // Instantiate a NSDateFormatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    // Set the dateFormatter format
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss.SS"];
    
    // Get the date time in NSString
    NSString *dateString = [dateFormatter stringFromDate:currentDateTime];
    
    return dateString;
    
}


@end
