//
//  ViewController.m
//  ApiPagos
//
//  Created by mlgw on 10/19/20.
//

#import "MainViewController.h"
#import "BankListViewController.h"
#import "HTTPHandler.h"
#import "PaymentMethod.h"
#import "Loader.h"
#import "Definitions.h"

static NSString * const API_PAYMENT_METHODS = @"https://api.mercadopago.com/v1/payment_methods";

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textFieldAmount;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerPaymentMethods;
@property (weak, nonatomic) IBOutlet UILabel *lblError;
@property (strong, nonatomic) NSMutableString* currentAmount;
@property (strong, nonatomic) NSArray* paymentMethods;
@property (strong, nonatomic) Loader* loader;
@end



@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.loader = [[Loader alloc] initWithParent:self.view];
    self.paymentMethods = [[NSArray alloc] init];
    self.textFieldAmount.delegate = self;
    self.pickerPaymentMethods.delegate = self;
    self.pickerPaymentMethods.dataSource = self;
    
    [self requestPaymentMethods];
}

- (void)viewWillAppear:(BOOL)animated{
    self.textFieldAmount.text = @"";
    self.currentAmount = [[NSMutableString alloc] init];
}


-(void)requestPaymentMethods{
    [self.loader showLoading];
    [HTTPHandler requestContentFromURL:API_PAYMENT_METHODS withResponseBlock:^(NSURLRequest * _Nonnull request, id  _Nullable json, NSError * _Nullable error) {
        if (error) {
            [self showMessageError:@"Hubo un error al solicitar los medios de pagos."];
            [self.pickerPaymentMethods setHidden:YES];
        }
        else {
            self.paymentMethods = [self getPaymentMethodsFrom:json];
            [self.pickerPaymentMethods reloadAllComponents];
        }
        [self.loader hideLoading];
    }];
}

-(NSArray*)getPaymentMethodsFrom:(NSArray*)jsonArray{
    NSMutableArray* paymentMethods = [[NSMutableArray alloc] init];
    for (NSDictionary* method in jsonArray) {
        PaymentMethod* payMethod = [[PaymentMethod alloc] initFromDictionary:method];
        [paymentMethods addObject:payMethod];
    }
    
    return paymentMethods;
}

-(void)showMessageError:(NSString*)msg{
    [self.lblError setHidden:NO];
    [self.lblError setText:msg];
}

#pragma mark - UITextField delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *cleanCentString = [[textField.text
                                  componentsSeparatedByCharactersInSet:
                                  [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                                 componentsJoinedByString:@""];
    // Parse final integer value
    NSInteger centAmount = cleanCentString.doubleValue;
    // Check the user input
    if (string.length > 0) {
        // Digit added
        centAmount = centAmount * 10 + string.integerValue;
    }
    else {
        // Digit deleted
        centAmount = centAmount / 10;
    }
    // Update call amount value
    NSNumber *amount = [[NSNumber alloc] initWithDouble:(double)centAmount / 100];
    // Write amount with currency symbols to the textfield
    NSNumberFormatter *_currencyFormatter = [[NSNumberFormatter alloc] init];
    [_currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    textField.text = [_currencyFormatter stringFromNumber:amount];
    
    return false;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textFieldAmount resignFirstResponder];
}
#pragma mark - Navigation
- (IBAction)continuePressed:(id)sender {
    [self.lblError setHidden:YES];
    if ([self.textFieldAmount.text length] == 0) {
        [self showMessageError:@"Por favor ingrese un monto."];
        return;
    }
    else if ([self.currentAmount doubleValue] <=0){
        [self showMessageError:@"Ingrese un monto mayor a 0."];
        return;
    }
    [self performSegueWithIdentifier:@"showBankList" sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    BankListViewController* vc = [segue destinationViewController];
    double amount = [self.currentAmount doubleValue];
    vc.amount = [NSNumber numberWithDouble:amount/100];
    NSInteger row = [self.pickerPaymentMethods selectedRowInComponent:0];
    vc.paymentMethod = self.paymentMethods[row];
}

#pragma mark -  UIPickerView Delegate
- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.paymentMethods.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    PaymentMethod* paymentMethod = self.paymentMethods[row];
    return paymentMethod.name;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    if (!view) {
        view = [[UILabel alloc] init];
    }
    UILabel* label = (UILabel*)view;
    PaymentMethod* paymentMethod = self.paymentMethods[row];
    
    [label setFont:[UIFont fontWithName:UIFONT_DEFAULT size:FONT_SIZE]];
    [label setText:paymentMethod.name];
    [label setTextAlignment:NSTextAlignmentCenter];
    
    return label;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [self.textFieldAmount resignFirstResponder];
}

@end
