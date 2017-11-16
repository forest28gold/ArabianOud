//
//  CardCellView.h
//  Arabian oud
//
//  Created by AppsCreationTech on 12/21/16.
//  Copyright © 2016 Henry Lam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardCellView : UIView

@property (strong, nonatomic) IBOutlet UIView *m_view;
@property (strong, nonatomic) IBOutlet UILabel *m_lblOff;
@property (strong, nonatomic) IBOutlet UILabel *m_lblStrOff;
@property (strong, nonatomic) IBOutlet UILabel *m_lblName;
@property (strong, nonatomic) IBOutlet UILabel *m_lblDiscount;
@property (strong, nonatomic) IBOutlet UILabel *m_lblPrice;
@property (strong, nonatomic) IBOutlet UIButton *m_btnShare;
@property (strong, nonatomic) IBOutlet UIButton *m_btnCart;
@property (strong, nonatomic) IBOutlet UIButton *m_btnNew;
@property (strong, nonatomic) IBOutlet UIImageView *m_imgProduct;
@property (strong, nonatomic) IBOutlet UIView *m_viewOff;

@end
