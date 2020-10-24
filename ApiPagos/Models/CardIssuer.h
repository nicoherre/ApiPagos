//
//  CardIssuer.h
//  ApiPagos
//
//  Created by mlgw on 10/21/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CardIssuer : NSObject
@property (strong, nonatomic) NSString* identifier;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* thumbnail;

-(id)initWithDictionary:(NSDictionary*)json;

@end


NS_ASSUME_NONNULL_END
