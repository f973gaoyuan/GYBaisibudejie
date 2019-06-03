//
//  NSDictionary+Property.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/5/18.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "NSDictionary+Property.h"

@implementation NSDictionary (Property)
- (void)createProperyCode:(NSDictionary*)dict {
    NSMutableString *propertyStr = [NSMutableString string];
    
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *pol = nil;
        NSString *typ = nil;
        if([obj isKindOfClass:[NSString class]]) {
            pol = @"strong";
            typ = @"NSString*";
        } else if([obj isKindOfClass:[NSArray class]]) {
            pol = @"strong";
            typ = @"NSArray*";
        } else if([obj isKindOfClass:[NSDictionary class]]) {
            pol = @"strong";
            typ = @"NSDictionary*";
        } else if([obj isKindOfClass:NSClassFromString(@"__NSCFBoolean")]) {
            pol = @"assign";
            typ = @"BOOL";
        } else if([obj isKindOfClass:NSClassFromString(@"__NSCFNumber")]) {
            pol = @"assign";
            typ = @"NSInteger";
        } else if([obj isKindOfClass:[NSNull class]]) {
            pol = @"strong";
            typ = @"NSNull*";
            //GYLog(@"%@", [obj class]);
        }
        
        NSString *str = [NSString stringWithFormat:@"@property (%@, nonatomic) %@ %@;", pol, typ, key];
        
        [propertyStr appendFormat:@"\n%@", str];
    }];
    
    GYLog(@"%@", propertyStr);
}
@end
