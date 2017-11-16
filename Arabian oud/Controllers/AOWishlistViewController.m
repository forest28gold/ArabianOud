//
//  AOWishlistViewController.m
//  Arabian oud
//
//  Created by AppsCreationTech on 12/26/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import "AOWishlistViewController.h"

@interface AOWishlistViewController () <UIAlertViewDelegate>
{
    NSInteger deleteIndex;
}

@end

@implementation AOWishlistViewController

@synthesize m_viewEmpty, m_collectionView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self onShowWishlistData];
    m_collectionView.alwaysBounceVertical = YES;
    
    if ([[GlobalData sharedGlobalData].g_userInfo.language isEqualToString:LANGUAGE_ARABIAN]) {
        m_collectionView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    }
    
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

- (void)onShowWishlistData {
    
    if ([GlobalData sharedGlobalData].g_arrayWishlist.count > 0) {
        m_viewEmpty.hidden = YES;
    } else {
        m_viewEmpty.hidden = NO;
    }
    [m_collectionView reloadData];
}

#pragma mark - UICollectionView DataSource Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [GlobalData sharedGlobalData].g_arrayWishlist.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = CGSizeMake(155*[GlobalData sharedGlobalData].g_autoFormat.SCALE_X, 249*[GlobalData sharedGlobalData].g_autoFormat.SCALE_Y);
    return size;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *_cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WishlistCell" forIndexPath:indexPath];
    
    UIImageView* _imgProduct = (UIImageView*)[_cell viewWithTag:1];
    UILabel* _lblName = (UILabel*)[_cell viewWithTag:2];
    UILabel* _lblCost = (UILabel*)[_cell viewWithTag:3];
    UIButton* _btnCart = (UIButton*)[_cell viewWithTag:4];
    UIButton* _btnDelete = (UIButton*)[_cell viewWithTag:5];
    
    ProductData *record = [GlobalData sharedGlobalData].g_arrayWishlist[indexPath.row];
    
    NSURL *imageURL = [NSURL URLWithString:record.image];
    [_imgProduct setShowActivityIndicatorView:YES];
    [_imgProduct setIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [_imgProduct sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"loading"]];
    
    _lblName.text = record.name;
    _lblCost.text = [self getFormattedPrice:record.discount];
    
    [_btnCart addTarget:self action:@selector(onAddCartItem:) forControlEvents:UIControlEventTouchUpInside];
    [_btnDelete addTarget:self action:@selector(onDeleteItem:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([[GlobalData sharedGlobalData].g_userInfo.language isEqualToString:LANGUAGE_ARABIAN]) {
        [_cell.contentView setTransform:CGAffineTransformMakeScale(-1, 1)];
    }
    
    return _cell;
}

- (NSString *)getFormattedPrice:(NSString *)price {
    
    if ([price containsString:@"."]) {
        NSArray *items = [price componentsSeparatedByString:@"."];
        price = [NSString stringWithFormat:@"%@.%@ %@", [items objectAtIndex:0], [[items objectAtIndex:1] substringToIndex:1], CURRENCY_CODE];
    } else {
        price = [NSString stringWithFormat:@"%@.0 %@", price, CURRENCY_CODE];
    }
    
    return price;
}

-(void)onAddCartItem:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_collectionView];
    NSIndexPath *indexPath = [self.m_collectionView indexPathForItemAtPoint:buttonFrameInTableView.origin];
    
    ProductData *record = [GlobalData sharedGlobalData].g_arrayWishlist[indexPath.row];
    
    [[GlobalData sharedGlobalData].g_arrayWishlist removeObjectAtIndex:indexPath.row];
    [[GlobalData sharedGlobalData].g_dataModel deleteWishlistDataDB:record];
    
    int countIndex = [self isContainsProductToCart:record];
    
//    [self addProductToCart:record contains:countIndex];
    
    if (countIndex == -1) {
        
        record.productCount = 1;
        [[GlobalData sharedGlobalData].g_arrayCart addObject:record];
        [[GlobalData sharedGlobalData].g_dataModel insertCartDataDB:record];
        
    } else {
        
        ProductData *recordCart = [GlobalData sharedGlobalData].g_arrayCart[countIndex];
        recordCart.productCount++;
        [[GlobalData sharedGlobalData].g_arrayCart replaceObjectAtIndex:countIndex withObject:recordCart];
        [[GlobalData sharedGlobalData].g_dataModel updateCartDataDB:recordCart];
    }
    
    [self.view makeToast:NSLocalizedString(@"item_added_to_cart", "") duration:1.0 position:CSToastPositionBottom];
    
    [self onShowWishlistData];
}

- (int)isContainsProductToCart:(ProductData*)product {
    
    for (int i = 0; i < [GlobalData sharedGlobalData].g_arrayCart.count; i++) {
        
        ProductData *record = [GlobalData sharedGlobalData].g_arrayCart[i];
        if ([record.productId isEqualToString:product.productId]) {
            return i;
        }
    }
    
    return -1;
}

-(void)onDeleteItem:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_collectionView];
    NSIndexPath *indexPath = [self.m_collectionView indexPathForItemAtPoint:buttonFrameInTableView.origin];
    
    deleteIndex = indexPath.row;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"confirm", "")
                                                    message:NSLocalizedString(@"alert_delete_item", "")
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"yes", "")
                                          otherButtonTitles:NSLocalizedString(@"no", ""), nil];
    
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    if (buttonIndex == 0) { // OK
        // do something here...
        
        ProductData *record = [GlobalData sharedGlobalData].g_arrayWishlist[deleteIndex];
        
        [[GlobalData sharedGlobalData].g_arrayWishlist removeObjectAtIndex:deleteIndex];
        [[GlobalData sharedGlobalData].g_dataModel deleteWishlistDataDB:record];
        
        [self onShowWishlistData];
        
    } else if (buttonIndex == 1) { // Cancel
        //Code for cancel button
        
    }
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onContinueShopping:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
