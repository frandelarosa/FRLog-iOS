//
//  FRLog.h
//  FRLog iOS
//
//  Created by Francisco de la Rosa on 17/01/15.
//  Copyright (c) 2015 Fran. All rights reserved.
//

#import "FRLogObject.h"
#import "FRLogURL.h"
#import <Foundation/Foundation.h>
#import "GCDAsyncUdpSocket.h"

#ifdef DEBUG
    #define FRLogURL(fmt, ...)  { FRLogURL *frlobject = [FRLogURL new]; [frlobject setType:FRLogTypeURL]; [frlobject setUrl:[NSString stringWithFormat:fmt, ##__VA_ARGS__]]; [[FRLog sharedManager] sendLogObject:frlobject]; }

    #define FRLogInfo(fmt, ...)  { FRLogObject *frlobject = [FRLogObject new]; [frlobject setType:FRLogTypeInfo]; [frlobject setClassname:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__]]; [frlobject setLine:[NSString stringWithFormat:@"%d", __LINE__]]; [frlobject setContent:[NSString stringWithFormat:fmt, ##__VA_ARGS__]]; [[FRLog sharedManager] sendLogObject:frlobject];}

    #define FRLogError(fmt, ...)  { FRLogObject *frlobject = [FRLogObject new]; [frlobject setType:FRLogTypeError]; [frlobject setClassname:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__]]; [frlobject setLine:[NSString stringWithFormat:@"%d", __LINE__]]; [frlobject setContent:[NSString stringWithFormat:fmt, ##__VA_ARGS__]]; }
#else
    #define FRLogURL(...)
    #define FRLogInfo(...)
    #define FRLogError(...)
#endif


@interface FRLog : NSObject <GCDAsyncUdpSocketDelegate> {
    GCDAsyncUdpSocket *clientSocket;
}

+ (id)sharedManager;

- (void)sendLogURL:(FRLogURL *)log_obj;
- (void)sendLogObject:(FRLogObject *)log_obj;

@end
