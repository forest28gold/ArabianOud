//
//  AOCheckOutViewController.h
//  Arabian oud
//
//  Created by AppsCreationTech on 1/2/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AOCheckOutViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *m_btnMethod;
@property (strong, nonatomic) IBOutlet UIImageView *m_imgArrow;
@property (strong, nonatomic) IBOutlet UIView *m_viewMethod;

@property (strong, nonatomic) IBOutlet UITableView *m_tableView;

@property (strong, nonatomic) IBOutlet UIView *m_viewCoupon;
@property (strong, nonatomic) IBOutlet UITextField *m_txtCoupon;
@property (strong, nonatomic) IBOutlet UIButton *m_btnApply;
@property (strong, nonatomic) IBOutlet UIButton *m_btnCancel;
@property (strong, nonatomic) IBOutlet UILabel *m_lblDiscount;
@property (strong, nonatomic) IBOutlet UILabel *m_lblDiscountTotal;

@property (strong, nonatomic) IBOutlet UILabel *m_lblUsername;
@property (strong, nonatomic) IBOutlet UILabel *m_lblLocation;
@property (strong, nonatomic) IBOutlet UILabel *m_lblPhone;

@property (strong, nonatomic) IBOutlet UILabel *m_lblSubTotal;
@property (strong, nonatomic) IBOutlet UILabel *m_lblShipping;
@property (strong, nonatomic) IBOutlet UILabel *m_lblGrandTotal;

@end
