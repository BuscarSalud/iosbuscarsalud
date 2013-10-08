//
//  iOSRequest.m
//  BuscarSalud
//
//  Created by FELIX OLIVARES on 2/24/13.
//  Copyright (c) 2013 FELIX OLIVARES. All rights reserved.
//

#import "iOSRequest.h"
#import "NSString+WebService.h"

@implementation iOSRequest

+(void)requestToPath:(NSString *)path onCompletion:(RequestCompletionHandler)complete
{
    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:path]
                                                  cachePolicy:NSURLCacheStorageAllowedInMemoryOnly
                                              timeoutInterval:40];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:backgroundQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                               NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                               if (complete) complete(result,error);
                               
                           }];
}

+(void)getLocations:(NSString *)latitude
       andLongitude:(NSString *)longitude
       andSpecialty:(NSString *)specialty
       andState:(NSString *)state
       andOrder:(NSString *)order
       onCompletion:(RequestDictionaryCompletionHandler)complete
{
    NSString *fullPath = [[NSString alloc]init];
    NSString *basePath = @"http://ws.buscarsalud.com/get_info.php?";
   
    if ([state isEqualToString:@""]) {
        NSLog(@"Crash 5"); 
        if ([order isEqualToString:@""]){
            fullPath = [basePath stringByAppendingFormat:@"lat=%@&lon=%@&especialidad=%@",latitude, longitude, specialty];
        }else{
            if ([order isEqualToString:@"distancia"]) {
                fullPath = [basePath stringByAppendingFormat:@"lat=%@&lon=%@&especialidad=%@&orden=%@", latitude, longitude,specialty, order];
            }else{
                fullPath = [basePath stringByAppendingFormat:@"especialidad=%@&orden=%@", specialty, order];
            }
        }
    }else{
        if ([order isEqualToString:@""]){
            fullPath = [basePath stringByAppendingFormat:@"lat=%@&lon=%@&especialidad=%@&estado=%@",latitude, longitude, specialty, state];
        }else{
            if ([order isEqualToString:@"distancia"]) {
                fullPath = [basePath stringByAppendingFormat:@"lat=%@&lon=%@&especialidad=%@&estado=%@&orden=%@", latitude, longitude, specialty, state, order];
            }else{
                fullPath = [basePath stringByAppendingFormat:@"especialidad=%@&estado=%@&orden=%@", specialty, state, order];
            }
        }
    }

    NSLog(@"%@", fullPath);
    [iOSRequest requestToPath:fullPath onCompletion:^(NSString *result, NSError *error){
        if (error || [result isEqualToString:@"[]"]){
            NSLog(@"No Data");
            if (complete) complete(nil);
        }
        else{
            NSDictionary *user = [result JSON];
            if (complete) complete(user);
        }
    }];
}

+(void)getDoctor:(NSString *)nid onCompletion:(RequestDictionaryCompletionHandler)complete
{
    NSString *basePath = @"http://ws.buscarsalud.com/get_doctor_info.php?";
    NSString *fullPath = [basePath stringByAppendingFormat:@"nid=%@", nid];
    [iOSRequest requestToPath:fullPath onCompletion:^(NSString *result, NSError *error){
        if (error || [result isEqualToString:@"[]"]){
            NSLog(@"No Data");
            if (complete) complete(nil);
        }
        else{
            NSDictionary *user = [result JSON];
            if (complete) complete(user);
        }
    }];

}

+(void)getTermsOfUse:(RequestTermsCompletionHandler)complete
{
    NSString *path = @"http://ws.buscarsalud.com/get_terms_of_use.php";
    [iOSRequest requestToPath:path onCompletion:^(NSString *result, NSError *error){
        if (error || [result isEqualToString:@"[]"]){
            NSLog(@"No Data");
            if (complete) complete(nil);
        }
        else{
            if (complete) complete(result);
        }
    }];
}

+(void)getSpecialtiesAndStates:(NSString *)specialty andState:(NSString *)state andAll:(NSString *)all onCompletion :(RequestDictionaryCompletionHandler)complete
{
    NSString *path = @"http://ws.buscarsalud.com/get_specialties_states.php";
    NSString *flag = @"no";
    
    if ([all isEqualToString:@"especialidad"]) {
        flag = @"yes";
        NSString *fullPath = [NSString stringWithFormat:@"%@?todos=especialidad", path];
        [iOSRequest requestToPath:fullPath onCompletion:^(NSString *result, NSError *error){
            if (error || [result isEqualToString:@"[]"]){
                NSLog(@"No Data");
                if (complete) complete(nil);
            }
            else{
                NSDictionary *allSpecialties = [result JSON];
                if (complete) complete(allSpecialties);
            }
        }];
    }
    if ([all isEqualToString:@"estado"]) {
        flag = @"yes";
        NSString *fullPath = [NSString stringWithFormat:@"%@?todos=estado", path];
        [iOSRequest requestToPath:fullPath onCompletion:^(NSString *result, NSError *error){
            if (error || [result isEqualToString:@"[]"]){
                NSLog(@"No Data");
                if (complete) complete(nil);
            }
            else{
                NSDictionary *allStates = [result JSON];
                if (complete) complete(allStates);
            }
        }];
    }
    
    if ([state isEqualToString:@""] && [flag isEqualToString:@"no"]) {
        NSString *fullPath = [NSString stringWithFormat:@"%@?especialidad=%@", path, specialty];
        [iOSRequest requestToPath:fullPath onCompletion:^(NSString *result, NSError *error){
            if (error || [result isEqualToString:@"[]"]){
                NSLog(@"No Data");
                if (complete) complete(nil);
            }
            else{
                NSDictionary *states = [result JSON];
                if (complete) complete(states);
            }
        }];
        NSLog(@"%@", fullPath);
    }
}

@end
