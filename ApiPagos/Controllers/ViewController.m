//
//  ViewController.m
//  ApiPagos
//
//  Created by mlgw on 10/19/20.
//

#import "ViewController.h"
#import "BankListViewController.h"
#import "HTTPHandler.h"
#import "PaymentMethod.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textFieldAmount;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerPaymentMethods;
@property (strong, nonatomic) NSMutableString* currentAmount;
@property (strong, nonatomic) NSArray* paymentMethods;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self requestPaymentMethods];
    
    self.paymentMethods = [[NSArray alloc] init];
    self.textFieldAmount.delegate = self;
    self.pickerPaymentMethods.delegate = self;
    self.pickerPaymentMethods.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated{
    self.textFieldAmount.text = @"";
    self.currentAmount = [[NSMutableString alloc] init];
}


-(void)requestPaymentMethods{
    [HTTPHandler requestContentFromURL:@"https://api.mercadopago.com/v1/payment_methods" withResponseBlock:^(NSURLRequest * _Nonnull request, id  _Nullable json, NSError * _Nullable error) {
        if (error) {
            // mostrar error
        }
        else {
            self.paymentMethods = [self getPaymentMethodsFrom:json];
            [self.pickerPaymentMethods reloadAllComponents];
        }
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


#pragma mark - UITextField delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([[NSScanner scannerWithString:string] scanInt:nil]) {
        [self.currentAmount appendString:string];
    }
    
    [self formatCurrenct:self.currentAmount];
    return false;
}

-(void)formatCurrenct:(NSString*)amountInput{
    NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    NSNumber* numberFromField = [[NSNumber alloc] initWithDouble:([amountInput doubleValue]/100)];
    [self.textFieldAmount setText:[formatter stringFromNumber:numberFromField]];
}

#pragma mark - Navigation
- (IBAction)continuePressed:(id)sender {
    if ([self.textFieldAmount.text length] == 0) {
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

@end
