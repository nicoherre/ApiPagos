//
//  PayerCost.m
//  ApiPagos
//
//  Created by mlgw on 10/24/20.
//

#import "PayerCost.h"

@implementation PayerCost

-(id)initWithDictionary:(NSDictionary*)dict{
    self = [super init];
    if (self) {
        self.installments = [dict objectForKey:@"installments"];
        self.message = [dict objectForKey:@"recommended_message"];
        self.installment_amount = [dict objectForKey:@"installment_amount"];
        self.total_amount = [dict objectForKey:@"total_amount"];
    }
    return self;
}

@end
