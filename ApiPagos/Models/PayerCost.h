//
//  PayerCost.h
//  ApiPagos
//
//  Created by mlgw on 10/24/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PayerCost : NSObject
@property (strong, nonatomic) NSNumber* installments;
@property (strong, nonatomic) NSString* message;
@property (strong, nonatomic) NSNumber* installment_amount;
@property (strong, nonatomic) NSNumber* total_amount;

-(id)initWithDictionary:(NSDictionary*)dict;
@end

NS_ASSUME_NONNULL_END
