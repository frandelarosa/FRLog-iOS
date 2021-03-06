//
//  FRLog.m
//  FRLog iOS
//
//  Created by Francisco de la Rosa on 17/01/15.
//  Copyright (c) 2015 Fran. All rights reserved.
//

#define SERVER_URL  @"http://localhost"
#define SERVER_PORT @"3000"

#define REQUEST_WORD @"req="

#import "FRLog.h"
#import "FRLogObject.h"


@implementation FRLog

#pragma mark -
#pragma mark Life Cycle
#pragma mark -

+ (id)sharedManager {
    
    static FRLog *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    
    return sharedMyManager;
    
}

- (id)init {
    
    if (self = [super init]) {
        
        NSError *error = nil;
        
        clientSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        if (![clientSocket bindToPort:0 error:&error])
        {
            NSLog(@"Error binding: %@", error);
            return nil;
        }
        if (![clientSocket beginReceiving:&error])
        {
            NSLog(@"Error receiving: %@", error);
            return nil;
        }
        
        NSLog(@"Ready");
        
        //[self sendTestMessage];
        
        
        
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}


#pragma mark -
#pragma mark Send
#pragma mark -

- (void)sendLogObject:(id)log_obj {
    
    NSDictionary *jsonDict;
    
    if ([log_obj isKindOfClass:[FRLogURL class]]){
        jsonDict = [self parseURLToDictionary:log_obj];
    }else{
        jsonDict = [self parseObjectToDictionary:log_obj];
    }
    
    // Parse JSONDict into NSString
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:NSJSONWritingPrettyPrinted error:&error];
    //NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    //[self sendData:jsonStr];
    [clientSocket sendData:jsonData toHost:@"0.0.0.0" port:1283 withTimeout:-1 tag:1];
    
}


#pragma mark -
#pragma mark Parse
#pragma mark -

- (NSDictionary *)parseObjectToDictionary:(FRLogObject *)log_obj {
    
    // Date
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-YYYY HH:mm:ss.SSS"];
    NSString *dateStr = [dateFormat stringFromDate:[NSDate date]];
    [log_obj setDate:dateStr];
    
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                              [NSString stringWithFormat:@"%lu", (unsigned long)log_obj.type], @"obj_type",
                              [NSString stringWithFormat:@"%@", log_obj.classname],            @"obj_classname",
                              [NSString stringWithFormat:@"%@", log_obj.line],                 @"obj_line",
                              [NSString stringWithFormat:@"%@", log_obj.content],              @"obj_content",
                              [NSString stringWithFormat:@"%@", log_obj.date],                 @"obj_date",
                              nil];
    
    return jsonDict;
    
}

- (NSDictionary *)parseURLToDictionary:(FRLogURL *)url_obj {
    
    NSString *url = url_obj.url;
    NSString *requestName;
    
    // Find request name and save it in FRLogURL object
    NSRange rangeInit = [url rangeOfString:REQUEST_WORD];
    
    if (rangeInit.location != NSNotFound) {
        
        // Find & character
        NSRange rangeLimit = [url rangeOfString:@"&" options:0 range:NSMakeRange(rangeInit.location, (url.length - rangeInit.location))];
        
        if (rangeLimit.location > url.length){
            requestName = [url substringFromIndex:rangeInit.location + rangeInit.length];
        }else {
            requestName = [url substringWithRange:NSMakeRange(rangeInit.location + rangeInit.length, (rangeLimit.location - rangeInit.location - rangeInit.length))];
        }
        
        [url_obj setRequestName:requestName];
        
    } else {
        requestName = @"REQUEST NAME NOT FOUND";
    }
    
    // Date
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-YYYY HH:mm:ss.SSS"];
    NSString *dateStr = [dateFormat stringFromDate:[NSDate date]];
    [url_obj setDate:dateStr];
    
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                              [NSString stringWithFormat:@"%lu", (unsigned long)url_obj.type], @"obj_type",
                              [NSString stringWithFormat:@"%@", url_obj.requestName],          @"obj_requestname",
                              [NSString stringWithFormat:@"%@", url_obj.url],                  @"obj_url",
                              [NSString stringWithFormat:@"%@", url_obj.date],                 @"obj_date",
                              nil];
    
    return jsonDict;
    
}


@end
