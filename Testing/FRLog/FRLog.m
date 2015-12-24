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

#define FRLOG_OBJ_TYPE    @"obj_type"
#define FRLOG_OBJ_DATE    @"obj_date"
#define FRLOG_OBJ_CLASS   @"obj_classname"
#define FRLOG_OBJ_LINE    @"obj_line"
#define FRLOG_OBJ_CONTENT @"obj_content"
#define FRLOG_OBJ_URL     @"obj_url"
#define FRLOG_OBJ_REQ     @"obj_requestName"

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

- (NSDictionary *)getDefaultDictionary:(id)logObj {

    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                              [NSString stringWithFormat:@"%li", [[logObj valueForKey:@"type"] integerValue]], FRLOG_OBJ_TYPE,
                              [NSString stringWithFormat:@"%@",  [logObj  valueForKey:@"date"]],               FRLOG_OBJ_DATE,
                              [NSString stringWithFormat:@"%@",  [logObj  valueForKey:@"classname"]],          FRLOG_OBJ_CLASS,
                              [NSString stringWithFormat:@"%@",  [logObj  valueForKey:@"line"]],               FRLOG_OBJ_LINE,
                              [NSString stringWithFormat:@"%@",  [logObj  valueForKey:@"content"]],            FRLOG_OBJ_CONTENT,
                              nil];
    
    return jsonDict;
    
    
}

- (NSDictionary *)parseObjectToDictionary:(FRLogObject *)log_obj {
    
    // Add common properties
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[self getDefaultDictionary:log_obj]];
    
    NSDictionary *root = [[NSDictionary alloc] initWithObjectsAndKeys:
                          [NSString stringWithFormat:@"%li", FRLogTypeInfo], @"type",
                          dict, @"log", nil];
    
    return root;
    
}

- (NSDictionary *)parseURLToDictionary:(FRLogURL *)url_obj {
    
    NSString *url = url_obj.url;
    NSString *requestName;
    
    // Find request name and save it in FRLogURL object
    NSRange rangeInit = [url rangeOfString:REQUEST_WORD];
    
    if (rangeInit.location != NSNotFound) {
        // Find & character
        NSRange rangeLimit = [url rangeOfString:@"&" options:0 range:NSMakeRange(rangeInit.location, (url.length - rangeInit.location))];
        requestName = [url substringWithRange:NSMakeRange(rangeInit.location + rangeInit.length, (rangeLimit.location - rangeInit.location - rangeInit.length))];
        [url_obj setRequestName:requestName];
        
    } else {
        // Not found
    }
    
    // Add common properties
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[self getDefaultDictionary:url_obj]];
    
    // Custom properties
    [dict setObject:[NSString stringWithFormat:@"%@", url_obj.url]         forKey:FRLOG_OBJ_URL];
    [dict setObject:[NSString stringWithFormat:@"%@", url_obj.requestName] forKey:FRLOG_OBJ_REQ];
    
    NSDictionary *root = [[NSDictionary alloc] initWithObjectsAndKeys:
                          [NSString stringWithFormat:@"%li", FRLogTypeURL], @"type",
                          dict, @"log", nil];
    
    return root;

}


@end
