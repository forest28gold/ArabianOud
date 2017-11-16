//
//  AOOrderDetailsViewController.h
//  Arabian oud
//
//  Created by AppsCreationTech on 1/3/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AOOrderDetailsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *m_lblOrderNo;
@property (strong, nonatomic) IBOutlet UILabel *m_lblOrderDate;
@property (strong, nonatomic) IBOutlet UILabel *m_lblPaymentMethod;

@property (strong, nonatomic) IBOutlet UILabel *m_lblUsername;
@property (strong, nonatomic) IBOutlet UILabel *m_lblLocation;
@property (strong, nonatomic) IBOutlet UILabel *m_lblPhone;

@property (strong, nonatomic) IBOutlet UITableView *m_tableView;

@property (strong, nonatomic) IBOutlet UILabel *m_lblSubTotal;
@property (strong, nonatomic) IBOutlet UILabel *m_lblShipping;
@property (strong, nonatomic) IBOutlet UILabel *m_lblGrandTotal;

@property (strong, nonatomic) IBOutlet UILabel *m_lblDiscount;
@property (strong, nonatomic) IBOutlet UILabel *m_lblDiscountTotal;

@end
