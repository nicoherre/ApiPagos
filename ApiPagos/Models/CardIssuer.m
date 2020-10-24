//
//  CardIssuer.m
//  ApiPagos
//
//  Created by mlgw on 10/21/20.
//

#import "CardIssuer.h"

@implementation CardIssuer

-(id)initWithDictionary:(NSDictionary*)json{
    self = [super init];
    if (self) {
        self.identifier = [json objectForKey:@"id"];
        self.name = [json objectForKey:@"name"];
        self.thumbnail = [json objectForKey:@"thumbnail"];
    }
    return self;
}


@end
