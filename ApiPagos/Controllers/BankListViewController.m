//
//  BankListVCViewController.m
//  ApiPagos
//
//  Created by mlgw on 10/21/20.
//

#import "BankListViewController.h"
#import "HTTPHandler.h"
#import "CardIssuer.h"
#import "InstallmentsViewController.h"

@interface BankListViewController ()
@property (weak, nonatomic) IBOutlet UIPickerView *pickerBankList;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (strong, nonatomic) NSArray* card_issuers;
@end

@implementation BankListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lblTitle.text = [NSString stringWithFormat:@"Seleccione el banco emisor de su tarjeta %@", self.paymentMethod.name];
    
    self.pickerBankList.delegate = self;
    self.pickerBankList.dataSource = self;
    
    self.card_issuers = [[NSArray alloc] init];
    
    [self requestCardIssuers];
}

-(void)requestCardIssuers{
    NSString* urlStr = [NSString stringWithFormat:@"https://api.mercadopago.com/v1/payment_methods/card_issuers?payment_method_id=%@", self.paymentMethod.identifier];
    [HTTPHandler requestContentFromURL:urlStr withResponseBlock:^(NSURLRequest * _Nonnull request, id  _Nullable json, NSError * _Nullable error) {
        if (error) {
            // mostrar error
        }
        else {
            self.card_issuers = [self getCardIssuersFrom:json];
            [self.pickerBankList reloadAllComponents];
        }
    }];
}

-(NSArray*)getCardIssuersFrom:(NSArray*)jsonArray{
    NSMutableArray* cardIssuers = [[NSMutableArray alloc] init];
    for (NSDictionary* bank in jsonArray) {
        CardIssuer* cardIssuer = [[CardIssuer alloc] initWithDictionary:bank];
        [cardIssuers addObject:cardIssuer];
    }
    
    return cardIssuers;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    InstallmentsViewController* vc = [segue destinationViewController];
    vc.paymentMethod = self.paymentMethod;
    NSInteger row = [self.pickerBankList selectedRowInComponent:0];
    vc.cardIssuer = self.card_issuers[row];
    vc.amount = self.amount;
}


#pragma mark -  UIPickerView Delegate
- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.card_issuers.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    CardIssuer* cardIssuer = self.card_issuers[row];
    return cardIssuer.name;
}
@end
