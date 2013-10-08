//
//  iOSRequest.h
//  BuscarSalud
//
//  Created by FELIX OLIVARES on 2/24/13.
//  Copyright (c) 2013 FELIX OLIVARES. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^RequestCompletionHandler)(NSString*, NSError*);
typedef void(^RequestDictionaryCompletionHandler)(NSDictionary*);
typedef void(^RequestTermsCompletionHandler)(NSString*);


@interface iOSRequest : NSObject
+(void)requestToPath:(NSString *)path onCompletion:(RequestCompletionHandler)complete;

+(void)getLocations: (NSString *)latitude
       andLongitude:(NSString *)longitude
       andSpecialty:(NSString *)specialty
       andState:(NSString *)state
       andOrder:(NSString *)order
       onCompletion: (RequestDictionaryCompletionHandler)complete;

+(void)getDoctor: (NSString *)nid
       onCompletion: (RequestDictionaryCompletionHandler)complete;

+(void)getTermsOfUse:(RequestTermsCompletionHandler)complete;

+(void)getSpecialtiesAndStates:(NSString *)specialty andState:(NSString *)state andAll:(NSString *)all onCompletion:(RequestDictionaryCompletionHandler)complete;

@end
