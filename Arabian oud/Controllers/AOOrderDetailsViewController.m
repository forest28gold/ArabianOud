//
//  AOOrderDetailsViewController.m
//  Arabian oud
//
//  Created by AppsCreationTech on 1/3/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import "AOOrderDetailsViewController.h"

@interface AOOrderDetailsViewController ()
{
    float totalCost;
    float shippingCost;
    NSString *strIds;
    NSString *strQtys;
}

@end

@implementation AOOrderDetailsViewController

@synthesize m_tableView;
@synthesize m_lblPhone, m_lblOrderNo, m_lblLocation, m_lblShipping;
@synthesize m_lblSubTotal, m_lblUsername, m_lblOrderDate, m_lblGrandTotal, m_lblPaymentMethod;
@synthesize m_lblDiscount, m_lblDiscountTotal;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[GlobalData sharedGlobalData].g_dataModel onLoadProductDataDB:[GlobalData sharedGlobalData].g_orderData.orderID];
    
    m_lblOrderNo.text = [GlobalData sharedGlobalData].g_orderData.orderID;
    m_lblOrderDate.text = [self getFormattedDate:[GlobalData sharedGlobalData].g_orderData.date];
    m_lblPaymentMethod.text = [self onFormattedPaymentType:[GlobalData sharedGlobalData].g_orderData.type];
    
    m_lblUsername.text = [GlobalData sharedGlobalData].g_orderData.username;
    m_lblLocation.text = [GlobalData sharedGlobalData].g_orderData.address;
    m_lblPhone.text = [GlobalData sharedGlobalData].g_orderData.telephone;
    
    [self onCalculateGrandTotal];
    
    [[GlobalData sharedGlobalData].g_autoFormat resizeView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSString*)onFormattedPaymentType:(NSString*)type {
    
    if ([type isEqualToString:PAYMENT_CASH]) {
        type = NSLocalizedString(@"payment_cash", "");
    } else if ([type isEqualToString:PAYMENT_BANK]) {
        type = NSLocalizedString(@"payment_bank", "");
    } else if ([type isEqualToString:PAYMENT_PAYPAL]) {
        type = NSLocalizedString(@"payment_paypal", "");
    } else if ([type isEqualToString:PAYMENT_CREDIT]) {
        type = NSLocalizedString(@"payment_credit", "");
    }
    
    return type;
}

- (void)onCalculateGrandTotal {
    
    totalCost = 0.0f;
    shippingCost = 0.0f;
    strIds = @"";
    strQtys = @"";
    
    for (int i = 0; i < [GlobalData sharedGlobalData].g_arrayProduct.count; i++) {
        
        ProductData *record = [GlobalData sharedGlobalData].g_arrayProduct[i];
        totalCost += [record.discount floatValue] * record.productCount;
        
        if (i == 0) {
            strIds = record.productId;
            strQtys = [NSString stringWithFormat:@"%i", record.productCount];
        } else {
            strIds = [NSString stringWithFormat:@"%@,%@", strIds, record.productId];
            strQtys = [NSString stringWithFormat:@"%@,%i", strQtys, record.productCount];
        }
    }
    
    if (totalCost < 200) {
        shippingCost = 20.0f;
    }
    
    m_lblSubTotal.text = [self getFormattedPrice:[NSString stringWithFormat:@"%f", totalCost]];
    m_lblShipping.text = [self getFormattedPrice:[NSString stringWithFormat:@"%f", shippingCost]];
    
    if ([[GlobalData sharedGlobalData].g_orderData.couponCode isEqualToString:@""]) {
        
        m_lblDiscount.text = NSLocalizedString(@"discount", "");
        m_lblDiscountTotal.text = [self getFormattedPrice:[NSString stringWithFormat:@"- %f", 0.0f]];
        m_lblGrandTotal.text = [self getFormattedPrice:[NSString stringWithFormat:@"%f", totalCost + shippingCost]];
        
    } else {
        
        m_lblDiscount.text = [NSString stringWithFormat:@"%@ (%@)", NSLocalizedString(@"discount", ""), [GlobalData sharedGlobalData].g_orderData.couponCode];
        
        float discountCost = totalCost * ([[GlobalData sharedGlobalData].g_orderData.discountPercent floatValue] / 100);
        m_lblDiscountTotal.text = [self getFormattedPrice:[NSString stringWithFormat:@"- %f", discountCost]];
        m_lblGrandTotal.text = [self getFormattedPrice:[NSString stringWithFormat:@"%f", totalCost + shippingCost - discountCost]];
    }
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [GlobalData sharedGlobalData].g_arrayProduct.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100 * [GlobalData sharedGlobalData].g_autoFormat.SCALE_Y;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* _cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"OrderCell" forIndexPath:indexPath];
    
    
    UILabel *m_lblProductName = (UILabel*)[_cell viewWithTag:1];
    UILabel *m_lblCount = (UILabel*)[_cell viewWithTag:2];
    UILabel *m_lblSKU = (UILabel*)[_cell viewWithTag:3];
    UILabel *m_lblCost = (UILabel*)[_cell viewWithTag:4];
    UIImageView *m_imgProduct = (UIImageView*)[_cell viewWithTag:5];
    
    ProductData *record = [GlobalData sharedGlobalData].g_arrayProduct[indexPath.row];
    
    NSURL *imageURL = [NSURL URLWithString:record.image];
    [m_imgProduct setShowActivityIndicatorView:YES];
    [m_imgProduct setIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [m_imgProduct sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"loading"]];
    
    m_lblProductName.text = record.name;
    m_lblCost.text = [self getFormattedPrice:record.discount];
    m_lblCount.text = [NSString stringWithFormat:@"%ix", record.productCount];
    m_lblSKU.text = [NSString stringWithFormat:@"%@  : %@", NSLocalizedString(@"sku", ""), record.sku];
    
    UIView* m_view = (UIView*)[_cell viewWithTag:10];
    if (m_view.frame.size.width < self.m_tableView.frame.size.width) {
        [[GlobalData sharedGlobalData].g_autoFormat resizeView:_cell];
    }
    
    return _cell;
}

- (NSString*)getFormattedDate:(NSString*)strDate {
    
    NSArray *items = [strDate componentsSeparatedByString:@" "];
    NSArray *itemsDate = [[items objectAtIndex:0] componentsSeparatedByString:@"/"];
    int month = [[itemsDate objectAtIndex:0] intValue];
    NSString *strMonth = [itemsDate objectAtIndex:0];
    
    if (month == 1) {
        strMonth = NSLocalizedString(@"january", "");
    } else if (month == 2) {
        strMonth = NSLocalizedString(@"february", "");
    } else if (month == 3) {
        strMonth = NSLocalizedString(@"march", "");
    } else if (month == 4) {
        strMonth = NSLocalizedString(@"april", "");
    } else if (month == 5) {
        strMonth = NSLocalizedString(@"may", "");
    } else if (month == 6) {
        strMonth = NSLocalizedString(@"june", "");
    } else if (month == 7) {
        strMonth = NSLocalizedString(@"july", "");
    } else if (month == 8) {
        strMonth = NSLocalizedString(@"august", "");
    } else if (month == 9) {
        strMonth = NSLocalizedString(@"september", "");
    } else if (month == 10) {
        strMonth = NSLocalizedString(@"october", "");
    } else if (month == 11) {
        strMonth = NSLocalizedString(@"november", "");
    } else {
        strMonth = NSLocalizedString(@"december", "");
    }
    
    return [NSString stringWithFormat:@"%@ %@ %@ %@", strMonth, [itemsDate objectAtIndex:1], [itemsDate objectAtIndex:2], [items objectAtIndex:1]];
}

- (NSString *)getFormattedPrice:(NSString *)price {
    
    if ([price intValue] == 0) {
        price = NSLocalizedString(@"free", "");
    } else if ([price containsString:@"."]) {
        NSArray *items = [price componentsSeparatedByString:@"."];
        price = [NSString stringWithFormat:@"%@.%@ %@", [items objectAtIndex:0], [[items objectAtIndex:1] substringToIndex:2], CURRENCY_CODE];
    } else {
        price = [NSString stringWithFormat:@"%@.00 %@", price, CURRENCY_CODE];
    }
    
    return price;
}

@end
