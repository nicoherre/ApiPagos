//
//  BankListVCViewController.h
//  ApiPagos
//
//  Created by mlgw on 10/21/20.
//

#import <UIKit/UIKit.h>
#import "PaymentMethod.h"

NS_ASSUME_NONNULL_BEGIN

@interface BankListViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>
@property (strong, nonatomic) PaymentMethod* paymentMethod;
@property (strong, nonatomic) NSNumber* amount;
@end

NS_ASSUME_NONNULL_END
