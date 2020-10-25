//
//  InstallmentsVCViewController.m
//  ApiPagos
//
//  Created by mlgw on 10/23/20.
//

#import "InstallmentsViewController.h"
#import "HTTPHandler.h"
#import "PayerCost.h"
#import "Loader.h"
#import "UIImageView+Url.h"

@interface InstallmentsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lbl_amount;
@property (weak, nonatomic) IBOutlet UILabel *lbl_paymentMethod;
@property (weak, nonatomic) IBOutlet UILabel *lbl_cardIssuer;
@property (weak, nonatomic) IBOutlet UILabel *lbl_installments;
@property (weak, nonatomic) IBOutlet UILabel *lblError;
@property (weak, nonatomic) IBOutlet UIImageView *imgCardIssuer;
@property (weak, nonatomic) IBOutlet UIImageView *imgPayment;

@property (strong, nonatomic) Loader* loader;
@property (strong, nonatomic) NSMutableArray* installments;
@end

@implementation InstallmentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.loader = [[Loader alloc] initWithParent:self.view];
    [self requestInstallments];
    
    [self.lbl_cardIssuer setText:[NSString stringWithFormat:@"Emisor de la tarjeta: %@", self.cardIssuer.name]];
    [self.lbl_paymentMethod setText:[NSString stringWithFormat:@"Método de pago: %@", self.paymentMethod.name]];
    
    NSString* amountFormatter = [self formatCurrenct:[self.amount stringValue]];
    [self.lbl_amount setText:[NSString stringWithFormat:@"Cantidad: %@", amountFormatter]];
    
    [self.imgCardIssuer setImageWithUrl:[NSURL URLWithString:self.cardIssuer.thumbnail]];
    [self.imgPayment setImageWithUrl:[NSURL URLWithString:self.paymentMethod.thumbnail]];
}

-(NSString*)formatCurrenct:(NSString*)amountInput{
    NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    NSNumber* numberFromField = [[NSNumber alloc] initWithDouble:([amountInput doubleValue])];
    return [formatter stringFromNumber:numberFromField];
}

-(void)requestInstallments{
    [self.loader showLoading];
    NSString* installmentURL= @"https://api.mercadopago.com/v1/payment_methods/installments";
    NSString* urlStr = [NSString stringWithFormat:@"%@?payment_method_id=%@&issuer.id=%@&amount=%@", installmentURL, self.paymentMethod.identifier, self.cardIssuer.identifier, self.amount];
    [HTTPHandler requestContentFromURL:urlStr withResponseBlock:^(NSURLRequest * _Nonnull request, id  _Nullable json, NSError * _Nullable error) {
        if (error) {
            // mostrar error
        }
        else {
            NSMutableArray* payerCosts = [[NSMutableArray alloc] init];
            if (json && [json count] > 0) {
                NSDictionary* info = [json objectAtIndex:0];
                for (NSDictionary* payer in [info objectForKey:@"payer_costs"]) {
                    PayerCost* payerCost = [[PayerCost alloc] initWithDictionary:payer];
                    [payerCosts addObject:payerCost];
                }
                if ([payerCosts count] > 0) {
                    [self showInstallments:payerCosts[0]];
                }
            }
        }
        [self.loader hideLoading];
    }];
}


-(void)showInstallments:(PayerCost*)payer{
    [self.lbl_installments setText:payer.message];
}


#pragma mark - Navigation

-(IBAction)goToMainVC:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];

}

@end
