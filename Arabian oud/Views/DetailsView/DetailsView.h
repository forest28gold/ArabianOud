//
//  StepFlowView.h
//  Arabian oud
//
//  Created by AppsCreationTech on 12/27/16.
//  Copyright © 2016 Henry Lam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsView : UIView

@property (strong, nonatomic) IBOutlet UIView *m_viewDetails;
@property (strong, nonatomic) IBOutlet UIImageView *m_imgProduct;

@property (strong, nonatomic) IBOutlet UIView *m_viewShare;
@property (strong, nonatomic) IBOutlet UIButton *m_btnShare;
@property (strong, nonatomic) IBOutlet UIButton *m_btnShareFacebook;
@property (strong, nonatomic) IBOutlet UIButton *m_btnShareTwitter;
@property (strong, nonatomic) IBOutlet UIButton *m_btnSharePinterest;
@property (strong, nonatomic) IBOutlet UIButton *m_btnShareWhatsapp;
@property (strong, nonatomic) IBOutlet UIButton *m_btnShareEmail;

@property (strong, nonatomic) IBOutlet UILabel *m_lblCost;

@property (strong, nonatomic) IBOutlet UIButton *m_btnBuynow;
@property (strong, nonatomic) IBOutlet UIButton *m_btnCart;
@property (strong, nonatomic) IBOutlet UIButton *m_btnWishlist;

@end
