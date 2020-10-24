//
//  PaymentMethod.m
//  ApiPagos
//
//  Created by mlgw on 10/21/20.
//

#import "PaymentMethod.h"

@implementation PaymentMethod

- (id)initWithId:(NSString *)identifier name:(NSString *)name type:(NSString *)typeId thumbnail:(NSString *)thumbnail minAllowedAmount:(NSNumber *)min maxAllowedAmount:(NSNumber *)max{
    self = [super init];
    if (self) {
        self.identifier = identifier;
        self.name = name;
        self.type_id = typeId;
        self.thumbnail = thumbnail;
        self.min_allowed_amount = min;
        self.max_allowed_amount = max;
    }
    return self;
}


-(id)initFromDictionary:(NSDictionary*)json{
    NSNumber* min_amount = [json objectForKey:@"min_allowed_amount"];
    NSNumber* max_amount = [json objectForKey:@"max_allowed_amount"];
    
    return [self initWithId:[json objectForKey:@"id"]
                       name:[json objectForKey:@"name"]
                       type:[json objectForKey:@"payment_type_id"]
                  thumbnail:[json objectForKey:@"thumbnail"]
           minAllowedAmount:min_amount
           maxAllowedAmount:max_amount];
}
@end
