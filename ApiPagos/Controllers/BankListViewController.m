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
#import "Loader.h"
#import "Definitions.h"

static NSString * const API_CARD_ISSUERS = @"https://api.mercadopago.com/v1/payment_methods/card_issuers";

@interface BankListViewController ()
@property (weak, nonatomic) IBOutlet UIPickerView *pickerBankList;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblError;
@property (weak, nonatomic) IBOutlet UIButton *btnContinue;

@property (strong, nonatomic) Loader* loader;
@property (strong, nonatomic) NSArray* card_issuers;
@end

@implementation BankListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lblTitle.text = [NSString stringWithFormat:@"Buscando el emisor de su tarjeta %@", self.paymentMethod.name];
    
    self.pickerBankList.delegate = self;
    self.pickerBankList.dataSource = self;
    
    self.card_issuers = [[NSArray alloc] init];
    self.loader = [[Loader alloc] initWithParent:self.view];
    [self requestCardIssuers];
}

-(void)requestCardIssuers{
    [self.loader showLoading];
    NSString* param = @"payment_method_id";
    NSString* urlStr = [NSString stringWithFormat:@"%@?%@=%@", API_CARD_ISSUERS, param, self.paymentMethod.identifier];
    [HTTPHandler requestContentFromURL:urlStr withResponseBlock:^(NSURLRequest * _Nonnull request, id  _Nullable json, NSError * _Nullable error) {
        if (error) {
            [self.lblError setHidden:NO];
            [self.lblError setText:@"Hubo un error al cargar los datos."];
            [self.btnContinue setTitle:@"Regresar" forState:UIControlStateNormal];
        }
        else {
            self.card_issuers = [self getCardIssuersFrom:json];
            if ([self.card_issuers count] == 0) {
                [self.pickerBankList setHidden:YES];
                self.lblTitle.text = [NSString stringWithFormat:@"No se encontraron emisores para la tarjeta %@.", self.paymentMethod.name];
                [self.btnContinue setTitle:@"Regresar" forState:UIControlStateNormal];
            }
            else {
                self.lblTitle.text = [NSString stringWithFormat:@"Seleccione el emisor de su tarjeta %@", self.paymentMethod.name];
                [self.pickerBankList reloadAllComponents];
            }
        }
        [self.btnContinue setHidden:NO];
        [self.loader hideLoading];
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

-(IBAction)continuePressed:(id)sender{
    if ([self.card_issuers count] == 0) {
        //There aren't card issuers -> go back to main view
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self performSegueWithIdentifier:@"showInstallments" sender:nil];
    }
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

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    if (!view) {
        view = [[UILabel alloc] init];
    }
    UILabel* label = (UILabel*)view;
    CardIssuer* cardIssuer = self.card_issuers[row];
    
    [label setFont:[UIFont fontWithName:UIFONT_DEFAULT size:FONT_SIZE]];
    [label setText:cardIssuer.name];
    [label setTextAlignment:NSTextAlignmentCenter];
    
    return label;
}
@end
