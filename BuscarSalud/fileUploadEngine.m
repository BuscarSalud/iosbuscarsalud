//
//  fileUploadEngine.m
//  BuscarSalud
//
//  Created by FELIX OLIVARES on 4/30/13.
//  Copyright (c) 2013 FELIX OLIVARES. All rights reserved.
//

#import "fileUploadEngine.h"

@implementation fileUploadEngine

-(MKNetworkOperation *) postDataToServer:(NSMutableDictionary *)params path:(NSString *)path {
    
    MKNetworkOperation *op = [self operationWithPath:path
                                              params:params
                                          httpMethod:@"POST"
                                                 ssl:NO];
    return op;
}

-(MKNetworkOperation *) getDataToServer:(NSMutableDictionary *)params path:(NSString *)path {
    
    MKNetworkOperation *op = [self operationWithPath:path
                                              params:params
                                          httpMethod:@"GET"
                                                 ssl:NO];
    return op;
}

@end
