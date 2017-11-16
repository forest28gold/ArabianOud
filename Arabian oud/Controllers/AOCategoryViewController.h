//
//  AOCategoryViewController.h
//  Arabian oud
//
//  Created by AppsCreationTech on 12/26/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AOCategoryViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *m_lblTitle;
@property (strong, nonatomic) IBOutlet UIButton *m_btnWishlist;
@property (strong, nonatomic) IBOutlet UIButton *m_btnCart;

@property (strong, nonatomic) IBOutlet UIView *m_viewSearch;
@property (strong, nonatomic) IBOutlet UITextField *m_txtSearch;
@property (strong, nonatomic) IBOutlet UICollectionView *m_collectionView;

@end
