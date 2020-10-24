//
//  PaymentMethod.h
//  ApiPagos
//
//  Created by mlgw on 10/21/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PaymentMethod : NSObject
@property (strong, nonatomic) NSString* identifier;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* type_id;
@property (strong, nonatomic) NSString* thumbnail;
@property (strong, nonatomic) NSNumber* min_allowed_amount;
@property (strong, nonatomic) NSNumber* max_allowed_amount;
@property (strong, nonatomic) NSArray* info_needed;


-(id)initWithId:(NSString*)identifier name:(NSString*)name type:(NSString*)typeId thumbnail:(NSString*)thumbnail minAllowedAmount:(NSNumber*)min maxAllowedAmount:(NSNumber*)max;

-(id)initFromDictionary:(NSDictionary*)json;
@end

NS_ASSUME_NONNULL_END
