//
//  AOCategoryViewController.m
//  Arabian oud
//
//  Created by AppsCreationTech on 12/26/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import "AOCategoryViewController.h"
#import "AODetailsViewController.h"
#import "AOWishlistViewController.h"
#import "AOCartViewController.h"
#import "AOSearchViewController.h"

#import "UICollectionView+DragLoad.h"

@interface AOCategoryViewController () <UICollectionViewDragLoadDelegate, UIScrollViewDelegate>
{
    NSString *strCategoryID;
    NSMutableArray *arrayCategory;
    NSMutableArray *arrayCategoryFilter;
    NSString *strSearchkey;
}

@end

@implementation AOCategoryViewController

@synthesize m_btnWishlist, m_btnCart, m_lblTitle;
@synthesize m_txtSearch, m_collectionView, m_viewSearch;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    m_collectionView.alwaysBounceVertical = YES;
    
    m_lblTitle.text = [GlobalData sharedGlobalData].g_strCategory;
    strCategoryID = [GlobalData sharedGlobalData].g_strCategoryID;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    UITapGestureRecognizer *tapSearchRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSearchPerfumes)];
    tapSearchRecognizer.cancelsTouchesInView = NO;
    [m_viewSearch addGestureRecognizer:tapSearchRecognizer];
    
    [m_txtSearch addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [m_collectionView setDragDelegate:self refreshDatePermanentKey:@"RefreshList"];
    m_collectionView.showRefreshView = false;
    m_collectionView.showLoadMoreView = true;
    
    if ([[GlobalData sharedGlobalData].g_userInfo.language isEqualToString:LANGUAGE_ARABIAN]) {
        m_collectionView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    }
    
    [[GlobalData sharedGlobalData].g_autoFormat resizeView:self.view];
    
    if ([[GlobalData sharedGlobalData].g_userInfo.language isEqualToString:LANGUAGE_ARABIAN]) {
        
        m_btnCart.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        m_btnCart.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        m_btnCart.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        
        m_btnWishlist.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        m_btnWishlist.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        m_btnWishlist.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    }
    
    arrayCategoryFilter = [[NSMutableArray alloc] init];
    strSearchkey = @"";
    
    [self initLoadCategoryData];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateWishlistCartCount];
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

- (void)onSearchPerfumes {
    
    AOSearchViewController *nextCtrl = [[self storyboard]instantiateViewControllerWithIdentifier:VIEW_SEARCH];
    [self.navigationController pushViewController:nextCtrl animated:true];
}

- (void)updateWishlistCartCount {
    
    [m_btnWishlist setTitle:[NSString stringWithFormat:@"%i", (int)[GlobalData sharedGlobalData].g_arrayWishlist.count] forState:UIControlStateNormal];
    [m_btnCart setTitle:[NSString stringWithFormat:@"%i", (int)[GlobalData sharedGlobalData].g_arrayCart.count] forState:UIControlStateNormal];
}

- (void)initLoadCategoryData {
    
    arrayCategory = [[NSMutableArray alloc] init];
    
    SVPROGRESSHUD_SHOW;
    
    [[APIManager sharedManager] getCategoryProducts:TAG_GET_CATEGORY_PRODUCTS productId:strCategoryID startId:@"1" language:[GlobalData sharedGlobalData].g_userInfo.language success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        SVPROGRESSHUD_DISMISS;
        
        if (responseObject) {
            NSArray* products = responseObject[KEY_PRODUCTS];
            if (products && products.count > 0) {
                
                for (int i = 0; i < products.count; i++) {
                    
                    NSDictionary* productInfo = products[i];
                    
                    if (productInfo) {
                        
                        ProductData *record = [[ProductData alloc] init];
                        record.productId = [productInfo objectForKey:KEY_ID];
                        record.name = [productInfo objectForKey:KEY_NAME];
                        record.productDescription = [productInfo objectForKey:KEY_DESCRIPTION];
                        record.image = [productInfo objectForKey:KEY_IMAGE];
                        record.url = [productInfo objectForKey:KEY_URL];
                        record.sku = [productInfo objectForKey:KEY_SKU];
                        record.size = [productInfo objectForKey:KEY_SIZE];
                        record.type = [productInfo objectForKey:KEY_TYPE];
                        record.origin = [productInfo objectForKey:KEY_ORIGIN];
                        record.fragrance = [productInfo objectForKey:KEY_FRAGRANCE];
                        
                        if (![[productInfo objectForKey:KEY_PRICE] isKindOfClass:[NSString class]]) {
                            record.price = [[productInfo objectForKey:KEY_PRICE] stringValue];
                        } else {
                            record.price = [productInfo objectForKey:KEY_PRICE];
                        }
                        
                        if (![[productInfo objectForKey:KEY_DISCOUNT] isKindOfClass:[NSString class]]) {
                            record.discount = [[productInfo objectForKey:KEY_DISCOUNT] stringValue];
                        } else {
                            record.discount = [productInfo objectForKey:KEY_DISCOUNT];
                        }
                        
                        if (![[productInfo objectForKey:KEY_PERCENTAGE] isKindOfClass:[NSString class]]) {
                            record.percentage = [[productInfo objectForKey:KEY_PERCENTAGE] stringValue];
                        } else {
                            record.percentage = [productInfo objectForKey:KEY_PERCENTAGE];
                        }
                        
                        
                        [arrayCategory addObject:record];
                    }
                }
                
                [self filterContentForSearchText:strSearchkey];
                
            } else {
                SVPROGRESSHUD_DISMISS;
            }
        } else {
            SVPROGRESSHUD_DISMISS;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        SVPROGRESSHUD_DISMISS;
        
    }];
}

#pragma mark - Control datasource

- (void)finishRefresh {
    
    arrayCategory = [[NSMutableArray alloc] init];
    
    [[APIManager sharedManager] getCategoryProducts:TAG_GET_CATEGORY_PRODUCTS productId:strCategoryID startId:@"1" language:[GlobalData sharedGlobalData].g_userInfo.language success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            NSArray* products = responseObject[KEY_PRODUCTS];
            if (products && products.count > 0) {
                
                for (int i = 0; i < products.count; i++) {
                    
                    NSDictionary* productInfo = products[i];
                    
                    if (productInfo) {
                        
                        ProductData *record = [[ProductData alloc] init];
                        record.productId = [productInfo objectForKey:KEY_ID];
                        record.name = [productInfo objectForKey:KEY_NAME];
                        record.productDescription = [productInfo objectForKey:KEY_DESCRIPTION];
                        record.image = [productInfo objectForKey:KEY_IMAGE];
                        record.url = [productInfo objectForKey:KEY_URL];
                        record.sku = [productInfo objectForKey:KEY_SKU];
                        record.size = [productInfo objectForKey:KEY_SIZE];
                        record.type = [productInfo objectForKey:KEY_TYPE];
                        record.origin = [productInfo objectForKey:KEY_ORIGIN];
                        record.fragrance = [productInfo objectForKey:KEY_FRAGRANCE];
                        
                        if (![[productInfo objectForKey:KEY_PRICE] isKindOfClass:[NSString class]]) {
                            record.price = [[productInfo objectForKey:KEY_PRICE] stringValue];
                        } else {
                            record.price = [productInfo objectForKey:KEY_PRICE];
                        }
                        
                        if (![[productInfo objectForKey:KEY_DISCOUNT] isKindOfClass:[NSString class]]) {
                            record.discount = [[productInfo objectForKey:KEY_DISCOUNT] stringValue];
                        } else {
                            record.discount = [productInfo objectForKey:KEY_DISCOUNT];
                        }
                        
                        if (![[productInfo objectForKey:KEY_PERCENTAGE] isKindOfClass:[NSString class]]) {
                            record.percentage = [[productInfo objectForKey:KEY_PERCENTAGE] stringValue];
                        } else {
                            record.percentage = [productInfo objectForKey:KEY_PERCENTAGE];
                        }
                        
                        
                        [arrayCategory addObject:record];
                    }
                }
                
                [self filterContentForSearchText:strSearchkey];
                
                [m_collectionView finishRefresh];
                m_collectionView.showLoadMoreView = true;
                
            } else {
                
                [m_collectionView finishRefresh];
                [m_collectionView reloadData];
                m_collectionView.showLoadMoreView = true;
                
            }
        } else {
            
            [m_collectionView finishRefresh];
            [m_collectionView reloadData];
            m_collectionView.showLoadMoreView = true;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        SVPROGRESSHUD_DISMISS;
        
        [m_collectionView finishRefresh];
        [m_collectionView reloadData];
        m_collectionView.showLoadMoreView = true;
        
    }];
    
}

- (void)finishLoadMore {

    ProductData *record = arrayCategory[arrayCategory.count - 1];
    NSString *categoryLastID = record.productId;
    
    [[APIManager sharedManager] getCategoryProducts:TAG_GET_CATEGORY_PRODUCTS productId:strCategoryID startId:categoryLastID language:[GlobalData sharedGlobalData].g_userInfo.language success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        SVPROGRESSHUD_DISMISS;
        
        if (responseObject) {
            NSArray* products = responseObject[KEY_PRODUCTS];
            if (products && products.count > 0) {
                
                for (int i = 0; i < products.count; i++) {
                    
                    NSDictionary* productInfo = products[i];
                    
                    if (productInfo) {
                        
                        ProductData *record = [[ProductData alloc] init];
                        record.productId = [productInfo objectForKey:KEY_ID];
                        record.name = [productInfo objectForKey:KEY_NAME];
                        record.productDescription = [productInfo objectForKey:KEY_DESCRIPTION];
                        record.image = [productInfo objectForKey:KEY_IMAGE];
                        record.url = [productInfo objectForKey:KEY_URL];
                        record.sku = [productInfo objectForKey:KEY_SKU];
                        record.size = [productInfo objectForKey:KEY_SIZE];
                        record.type = [productInfo objectForKey:KEY_TYPE];
                        record.origin = [productInfo objectForKey:KEY_ORIGIN];
                        record.fragrance = [productInfo objectForKey:KEY_FRAGRANCE];
                        
                        if (![[productInfo objectForKey:KEY_PRICE] isKindOfClass:[NSString class]]) {
                            record.price = [[productInfo objectForKey:KEY_PRICE] stringValue];
                        } else {
                            record.price = [productInfo objectForKey:KEY_PRICE];
                        }
                        
                        if (![[productInfo objectForKey:KEY_DISCOUNT] isKindOfClass:[NSString class]]) {
                            record.discount = [[productInfo objectForKey:KEY_DISCOUNT] stringValue];
                        } else {
                            record.discount = [productInfo objectForKey:KEY_DISCOUNT];
                        }
                        
                        if (![[productInfo objectForKey:KEY_PERCENTAGE] isKindOfClass:[NSString class]]) {
                            record.percentage = [[productInfo objectForKey:KEY_PERCENTAGE] stringValue];
                        } else {
                            record.percentage = [productInfo objectForKey:KEY_PERCENTAGE];
                        }
                        
                        
                        [arrayCategory addObject:record];
                    }
                }
                
                [self filterContentForSearchText:strSearchkey];
                
                [m_collectionView finishLoadMore];
                m_collectionView.showLoadMoreView = true;
                
            } else {
                
                [m_collectionView finishLoadMore];
                [m_collectionView reloadData];
                m_collectionView.showLoadMoreView = false;
            }
        } else {
            
            [m_collectionView finishLoadMore];
            [m_collectionView reloadData];
            m_collectionView.showLoadMoreView = false;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [m_collectionView finishLoadMore];
        [m_collectionView reloadData];
        m_collectionView.showLoadMoreView = true;
        
    }];

}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onNavWishlist:(id)sender {
    
    AOWishlistViewController *nextCtrl = [[self storyboard]instantiateViewControllerWithIdentifier:VIEW_WISHLIST];
    [self.navigationController pushViewController:nextCtrl animated:true];
}

- (IBAction)onNavCart:(id)sender {
    
    AOCartViewController *nextCtrl = [[self storyboard]instantiateViewControllerWithIdentifier:VIEW_CART];
    [self.navigationController pushViewController:nextCtrl animated:true];
}

//------------  Search --------------

- (void)textFieldDidChange:(UITextField *)textField {
    
    if ([[GlobalData sharedGlobalData].g_userInfo.language isEqualToString:LANGUAGE_ARABIAN]) {
        
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\p{Arabic}"
                                                                               options:0
                                                                                 error:&error];
        NSTextCheckingResult *match = [regex firstMatchInString:textField.text
                                                        options:0
                                                          range:NSMakeRange(0, [textField.text length])];
        if (match || textField.text.length == 0) {
            textField.textAlignment = NSTextAlignmentRight;
        } else {
            textField.textAlignment = NSTextAlignmentLeft;
        }
    }
    
    strSearchkey = textField.text;
    [self filterContentForSearchText:strSearchkey];
}

-(void)filterContentForSearchText:(NSString*)searchText {
    
    NSMutableArray *tempResults = [NSMutableArray array];
    NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
    
    for (int i = 0; i < arrayCategory.count; i++) {
        
        ProductData *record = arrayCategory[i];
        
        NSString *storeString = record.name;
        NSRange storeRange = NSMakeRange(0, storeString.length);
        NSRange foundRange = [storeString rangeOfString:searchText options:searchOptions range:storeRange];
        if ([searchText isEqualToString:@""]) {
            [tempResults addObject:arrayCategory[i]];
        } else if (foundRange.length) {
            [tempResults addObject:arrayCategory[i]];
        }
    }
    
    [arrayCategoryFilter removeAllObjects];
    [arrayCategoryFilter addObjectsFromArray:tempResults];
    
    [m_collectionView reloadData];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == m_txtSearch) {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark Keyboard

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

#pragma mark - Drag delegate methods

- (void)dragTableDidTriggerRefresh:(UICollectionView *)collectionView
{
    //send refresh request(generally network request) here
    [self performSelector:@selector(finishRefresh) withObject:nil afterDelay:1];
}

- (void)dragTableRefreshCanceled:(UICollectionView *)collectionView
{
    //cancel refresh request(generally network request) here
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(finishRefresh) object:nil];
}

- (void)dragTableDidTriggerLoadMore:(UICollectionView *)collectionView
{
    //send load more request(generally network request) here
    [self performSelector:@selector(finishLoadMore) withObject:nil afterDelay:1];
}

- (void)dragTableLoadMoreCanceled:(UICollectionView *)collectionView
{
    //cancel load more request(generally network request) here
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(finishLoadMore) object:nil];
}

#pragma mark - UICollectionView DataSource Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return arrayCategoryFilter.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = CGSizeMake(155*[GlobalData sharedGlobalData].g_autoFormat.SCALE_X, 240*[GlobalData sharedGlobalData].g_autoFormat.SCALE_Y);
    return size;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *_cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WishlistCell" forIndexPath:indexPath];
    
    UIImageView* _imgProduct = (UIImageView*)[_cell viewWithTag:1];
    UILabel* _lblName = (UILabel*)[_cell viewWithTag:2];
    UILabel* _lblDiscount = (UILabel*)[_cell viewWithTag:3];
    UILabel* _lblPrice = (UILabel*)[_cell viewWithTag:4];
    UILabel* _lblOff = (UILabel*)[_cell viewWithTag:5];
    UIView* _viewProduct = (UIView*)[_cell viewWithTag:6];
    UIButton* _btnProduct = (UIButton*)[_cell viewWithTag:7];
    UIView* _viewOff = (UIView*)[_cell viewWithTag:9];
    
    _viewProduct.layer.cornerRadius = 10.0f;
    _imgProduct.layer.borderWidth = 5.0f;
    _imgProduct.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    ProductData *record = arrayCategoryFilter[indexPath.row];
    
    NSString *percentSymbol = @"%";
    _lblOff.text = [NSString stringWithFormat:@"%@%@", record.percentage, percentSymbol];
    
    NSURL *imageURL = [NSURL URLWithString:record.image];
    [_imgProduct setShowActivityIndicatorView:YES];
    [_imgProduct setIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [_imgProduct sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"loading"]];
    
    _lblName.text = record.name;
    _lblDiscount.text = [self getFormattedPrice:record.discount];
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[self getFormattedPrice:record.price]];
    [attributeString addAttribute:NSStrikethroughStyleAttributeName value:@1 range:NSMakeRange(0, [attributeString length])];
    _lblPrice.attributedText = attributeString;
    
    [_btnProduct addTarget:self action:@selector(onSelectItem:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([record.percentage isEqualToString:@"0"]) {
        _viewOff.hidden = YES;
        _lblPrice.hidden = YES;
    } else {
        _viewOff.hidden = NO;
        _lblPrice.hidden = NO;
    }
    
    if ([[GlobalData sharedGlobalData].g_userInfo.language isEqualToString:LANGUAGE_ARABIAN]) {
        [_cell.contentView setTransform:CGAffineTransformMakeScale(-1, 1)];
    }
    
    return _cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self dismissKeyboard];
}

-(void)onSelectItem:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_collectionView];
    NSIndexPath *indexPath = [self.m_collectionView indexPathForItemAtPoint:buttonFrameInTableView.origin];
    
    [GlobalData sharedGlobalData].g_productData = [[ProductData alloc] init];
    [GlobalData sharedGlobalData].g_productData = arrayCategoryFilter[indexPath.row];
    
    AODetailsViewController *nextCtrl = [[self storyboard]instantiateViewControllerWithIdentifier:VIEW_DETAILS];
    [self.navigationController pushViewController:nextCtrl animated:true];
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

@end
