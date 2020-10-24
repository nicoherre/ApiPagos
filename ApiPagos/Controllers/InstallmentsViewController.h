//
//  InstallmentsVCViewController.h
//  ApiPagos
//
//  Created by mlgw on 10/23/20.
//

#import <UIKit/UIKit.h>
#import "CardIssuer.h"
#import "PaymentMethod.h"
NS_ASSUME_NONNULL_BEGIN

@interface InstallmentsViewController : UIViewController
@property (strong, nonatomic) CardIssuer* cardIssuer;
@property (strong, nonatomic) PaymentMethod* paymentMethod;
@property (strong, nonatomic) NSNumber* amount;
@end

NS_ASSUME_NONNULL_END
