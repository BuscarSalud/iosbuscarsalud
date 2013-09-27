//
//  NSString+WebService.m
//  BuscarSalud
//
//  Created by FELIX OLIVARES on 2/24/13.
//  Copyright (c) 2013 FELIX OLIVARES. All rights reserved.
//

#import "NSString+WebService.h"

@implementation NSString (WebService)
-(id)JSON
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data
                                           options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments
                                             error:nil];
}
@end
