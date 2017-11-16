//
//  AOCreditCardViewController.h
//  Arabian oud
//
//  Created by AppsCreationTech on 1/3/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AOCreditCardViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *m_btnMethod;
@property (strong, nonatomic) IBOutlet UIImageView *m_imgArrow;
@property (strong, nonatomic) IBOutlet UIView *m_viewMethod;

@property (strong, nonatomic) IBOutlet UITextField *m_txtUserName;
@property (strong, nonatomic) IBOutlet UITextField *m_txtCardNumber;
@property (strong, nonatomic) IBOutlet UITextField *m_txtExpireDate;
@property (strong, nonatomic) IBOutlet UITextField *m_txtCVV;

@property (strong, nonatomic) IBOutlet UIView *m_viewPicker;
@property (strong, nonatomic) IBOutlet UIView *m_viewPurchase;

@end
