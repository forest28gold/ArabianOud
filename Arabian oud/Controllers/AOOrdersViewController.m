//
//  AOOrdersViewController.m
//  Arabian oud
//
//  Created by AppsCreationTech on 1/15/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import "AOOrdersViewController.h"
#import "AOOrderDetailsViewController.h"

@interface AOOrdersViewController ()

@end

@implementation AOOrdersViewController

@synthesize m_tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[GlobalData sharedGlobalData].g_dataModel onLoadOrderDataDB];
    
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

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [GlobalData sharedGlobalData].g_arrayOrder.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 124 * [GlobalData sharedGlobalData].g_autoFormat.SCALE_Y;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* _cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"OrderCell" forIndexPath:indexPath];
    
    UILabel *m_lblOrderNo = (UILabel*)[_cell viewWithTag:1];
    UILabel *m_lblOrderDate = (UILabel*)[_cell viewWithTag:2];
    UILabel *m_lblShippingCost = (UILabel*)[_cell viewWithTag:3];
    UILabel *m_lblTotalCost = (UILabel*)[_cell viewWithTag:4];
    UIButton *m_btnDetails = (UIButton*)[_cell viewWithTag:9];
    
    OrderData *record = [GlobalData sharedGlobalData].g_arrayOrder[indexPath.row];
    
    m_lblOrderNo.text = record.orderID;
    m_lblOrderDate.text = [self getFormattedDate:record.date];
    m_lblShippingCost.text = [self getFormattedPrice:record.ship];
    m_lblTotalCost.text = [self getFormattedPrice:record.total];
    
    [m_btnDetails addTarget:self action:@selector(onSelectOrder:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView* m_view = (UIView*)[_cell viewWithTag:10];
    if (m_view.frame.size.width < self.m_tableView.frame.size.width) {
        [[GlobalData sharedGlobalData].g_autoFormat resizeView:_cell];
    }
    
    return _cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [GlobalData sharedGlobalData].g_orderData = [[OrderData alloc] init];
    [GlobalData sharedGlobalData].g_orderData = [GlobalData sharedGlobalData].g_arrayOrder[indexPath.row];
    
    AOOrderDetailsViewController *nextCtrl = [[self storyboard] instantiateViewControllerWithIdentifier:VIEW_ORDER_DETAILS];
    [self.navigationController pushViewController:nextCtrl animated:true];
}

- (void)onSelectOrder:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    [GlobalData sharedGlobalData].g_orderData = [[OrderData alloc] init];
    [GlobalData sharedGlobalData].g_orderData = [GlobalData sharedGlobalData].g_arrayOrder[indexPath.row];
    
    AOOrderDetailsViewController *nextCtrl = [[self storyboard] instantiateViewControllerWithIdentifier:VIEW_ORDER_DETAILS];
    [self.navigationController pushViewController:nextCtrl animated:true];
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
        price = [NSString stringWithFormat:@"%@.%@ %@", [items objectAtIndex:0], [[items objectAtIndex:1] substringToIndex:1], CURRENCY_CODE];
    } else {
        price = [NSString stringWithFormat:@"%@.0 %@", price, CURRENCY_CODE];
    }
    
    return price;
}

@end
