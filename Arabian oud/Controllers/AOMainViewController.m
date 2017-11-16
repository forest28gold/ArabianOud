//
//  AOMainViewController.m
//  Arabian oud
//
//  Created by AppsCreationTech on 12/21/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import "AOMainViewController.h"
#import "AOMenuViewController.h"
#import "AOMenuARViewController.h"
#import "AOWishlistViewController.h"
#import "AOCartViewController.h"
#import "AOSearchViewController.h"
#import "AOCategoryViewController.h"
#import "AOAboutViewController.h"
#import "AOContactUsViewController.h"
#import "AODetailsViewController.h"

#import "REPagedScrollView.h"
#import "CardCellView.h"

@interface AOMainViewController () <MVRightSlideViewDelegate>
{
    int countNewArrival;
    int countLimit;
    NSMutableArray *arrayNewArrival;
}

@property (strong, nonatomic) AOMenuViewController *menuViewCtrl;
@property (strong, nonatomic) AOMenuARViewController *menuARViewCtrl;
@property (strong, nonatomic) REPagedScrollView *m_scrollView;

@end

@implementation AOMainViewController

@synthesize m_btnCart, m_btnWishlist;
@synthesize m_tableView, m_btnSearch, m_viewNewArrival;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[GlobalData sharedGlobalData].g_autoFormat resizeView:self.view];
    m_btnSearch.layer.cornerRadius = m_btnSearch.frame.size.height/2;
    
    [GlobalData sharedGlobalData].g_mainCtrl = self;
    
    [self initLoadNewArrivalView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateWishlistCartCount];
    
    if ([[GlobalData sharedGlobalData].g_userInfo.language isEqualToString:LANGUAGE_ARABIAN]) {
        
        _menuARViewCtrl = [[self storyboard] instantiateViewControllerWithIdentifier:VIEW_MENU_AR];
        CGSize size =  CGSizeMake(230 * [GlobalData sharedGlobalData].g_autoFormat.SCALE_X, [[UIScreen mainScreen] bounds].size.height);
        _rightMenuView = [[MVRightSlideView alloc] initWithRootView:self.view rightViewTop:0 rightViewSize:size];
        _rightMenuView.widthForSlideBack = 100.f;
        [_rightMenuView.rightView addSubview:_menuARViewCtrl.view];
        
        m_btnCart.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        m_btnCart.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        m_btnCart.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        
        m_btnWishlist.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        m_btnWishlist.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        m_btnWishlist.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        
        if ([[GlobalData sharedGlobalData].g_userInfo.signup isEqualToString:USER_LOGIN]) {
            _menuARViewCtrl.m_lblUserName.hidden = NO;
            _menuARViewCtrl.m_lblUserName.text = [GlobalData sharedGlobalData].g_userInfo.firstName;
        } else {
            _menuARViewCtrl.m_lblUserName.hidden = YES;
        }
        
    } else {
        
        _menuViewCtrl = [[self storyboard] instantiateViewControllerWithIdentifier:VIEW_MENU];
        _menuViewCtrl.view.frame = CGRectMake(0, 0, 230 * [GlobalData sharedGlobalData].g_autoFormat.SCALE_X, [[UIScreen mainScreen] bounds].size.height);
        _leftMenuView = [[MenuView alloc] initWithDependencyView:self.view MenuView:_menuViewCtrl.view isShowCoverView:YES];
    }
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

- (void)updateWishlistCartCount {
    
    [m_btnWishlist setTitle:[NSString stringWithFormat:@"%i", (int)[GlobalData sharedGlobalData].g_arrayWishlist.count] forState:UIControlStateNormal];
    [m_btnCart setTitle:[NSString stringWithFormat:@"%i", (int)[GlobalData sharedGlobalData].g_arrayCart.count] forState:UIControlStateNormal];
}

- (IBAction)onNavMenu:(id)sender {
    
    if ([[GlobalData sharedGlobalData].g_userInfo.language isEqualToString:LANGUAGE_ARABIAN]) {
        [_rightMenuView showRightView];
    } else {
        [_leftMenuView show];
    }
}

- (IBAction)onNavWishlist:(id)sender {

    AOWishlistViewController *nextCtrl = [[self storyboard]instantiateViewControllerWithIdentifier:VIEW_WISHLIST];
    [self.navigationController pushViewController:nextCtrl animated:true];
}

- (IBAction)onNavCart:(id)sender {
    
    AOCartViewController *nextCtrl = [[self storyboard]instantiateViewControllerWithIdentifier:VIEW_CART];
    [self.navigationController pushViewController:nextCtrl animated:true];
}

- (IBAction)onSearch:(id)sender {

    AOSearchViewController *nextCtrl = [[self storyboard]instantiateViewControllerWithIdentifier:VIEW_SEARCH];
    [self.navigationController pushViewController:nextCtrl animated:true];
}

//------------ Popular Categories --------------

- (void)onGotoPerfumes {
 
    AOCategoryViewController *nextCtrl = [[self storyboard]instantiateViewControllerWithIdentifier:VIEW_CATEGORY];
    [self.navigationController pushViewController:nextCtrl animated:true];
}

- (IBAction)onSelectOffers:(id)sender {
    
    [GlobalData sharedGlobalData].g_strCategory = CATEGORY_OFFERS;
    [GlobalData sharedGlobalData].g_strCategoryID = @"19";
    [self onGotoPerfumes];
}

- (IBAction)onSelectExclusive:(id)sender {
    
    [GlobalData sharedGlobalData].g_strCategory = CATEGORY_EXCLUSIVE;
    [GlobalData sharedGlobalData].g_strCategoryID = @"61";
    [self onGotoPerfumes];
}

- (IBAction)onSelectMen:(id)sender {
    
    [GlobalData sharedGlobalData].g_strCategory = CATEGORY_MEN;
    [GlobalData sharedGlobalData].g_strCategoryID = @"27";
    [self onGotoPerfumes];
}

- (IBAction)onSelectWomen:(id)sender {
    
    [GlobalData sharedGlobalData].g_strCategory = CATEGORY_WOMEN;
    [GlobalData sharedGlobalData].g_strCategoryID = @"26";
    [self onGotoPerfumes];
}

- (IBAction)onSelectBestSellers:(id)sender {
    
    [GlobalData sharedGlobalData].g_strCategory = CATEGORY_BEST_SELLERS;
    [GlobalData sharedGlobalData].g_strCategoryID = @"33";
    [self onGotoPerfumes];
}

//------------- New Arrival --------------

- (void)initLoadNewArrivalView {
    
    self.m_scrollView = [[REPagedScrollView alloc] initWithFrame:m_viewNewArrival.bounds];
//    self.m_scrollView.pageControl.pageIndicatorTintColor = [UIColor grayColor];
//    self.m_scrollView.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.m_scrollView.pageControl.hidden = YES;
    [m_viewNewArrival addSubview:self.m_scrollView];
    
    countLimit = 0;
    countNewArrival = 0;
    
    [self onLoadNewArrivalData];
}

- (void)onLoadNewArrivalData {
    
    arrayNewArrival = [[NSMutableArray alloc] init];
    
    [[APIManager sharedManager] getCategoryProducts:TAG_GET_CATEGORY_PRODUCTS productId:@"8" startId:@"0" language:[GlobalData sharedGlobalData].g_userInfo.language success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            NSArray* products = responseObject[KEY_PRODUCTS];
            if (products && products.count > 0) {
                
                countLimit = (int) products.count;
                
                if ([[GlobalData sharedGlobalData].g_userInfo.language isEqualToString:LANGUAGE_ARABIAN]) {
                    
                    for (int i = countLimit - 1; i >= 0; i--) {
                        
                        NSDictionary* productInfo = products[i];
                        
                        if (productInfo) {
                            
                            ProductData *record = [[ProductData alloc] init];
                            record.productId = [productInfo objectForKey:KEY_ID];
                            record.name = [productInfo objectForKey:KEY_NAME];
                            record.price = [productInfo objectForKey:KEY_PRICE];
                            record.discount = [productInfo objectForKey:KEY_DISCOUNT];
                            record.productDescription = [productInfo objectForKey:KEY_DESCRIPTION];
                            record.image = [productInfo objectForKey:KEY_IMAGE];
                            record.percentage = [productInfo objectForKey:KEY_PERCENTAGE];
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
                            
                            [arrayNewArrival addObject:record];
                            
                            CardCellView* cardCell = [[[NSBundle mainBundle] loadNibNamed:@"CardCellView" owner:self options:nil] firstObject];
                            cardCell.m_view.layer.cornerRadius = 10.0f;
                            cardCell.m_imgProduct.layer.borderWidth = 5.0f;
                            cardCell.m_imgProduct.layer.borderColor = [UIColor lightGrayColor].CGColor;
                            
                            NSString *percentSymbol = @"%";
                            cardCell.m_lblOff.text = [NSString stringWithFormat:@"%@%@", record.percentage, percentSymbol];
                            
                            NSURL *imageURL = [NSURL URLWithString:record.image];
                            [cardCell.m_imgProduct setShowActivityIndicatorView:YES];
                            [cardCell.m_imgProduct setIndicatorStyle:UIActivityIndicatorViewStyleWhite];
                            [cardCell.m_imgProduct sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"loading"]];
                            
                            cardCell.m_lblName.text = record.name;
                            cardCell.m_lblDiscount.text = [self getFormattedPrice:record.discount];
                            
                            NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[self getFormattedPrice:record.price]];
                            [attributeString addAttribute:NSStrikethroughStyleAttributeName value:@1 range:NSMakeRange(0, [attributeString length])];
                            cardCell.m_lblPrice.attributedText = attributeString;
                            
                            if ([record.percentage isEqualToString:@"0"]) {
                                cardCell.m_viewOff.hidden = YES;
                                cardCell.m_lblPrice.hidden = YES;
                            } else {
                                cardCell.m_viewOff.hidden = NO;
                                cardCell.m_lblPrice.hidden = NO;
                            }
                            
                            [cardCell.m_btnShare setImage:[UIImage imageNamed:@"new_cart"] forState:UIControlStateNormal];
                            [cardCell.m_btnCart setImage:[UIImage imageNamed:@"new_share"] forState:UIControlStateNormal];
                            cardCell.m_lblStrOff.text = @"خصم";
                            
                            [cardCell.m_btnNew addTarget:self action:@selector(onDetailView:) forControlEvents:UIControlEventTouchUpInside];
                            [cardCell.m_btnShare addTarget:self action:@selector(onNewArrivalShare:) forControlEvents:UIControlEventTouchUpInside];
                            [cardCell.m_btnCart addTarget:self action:@selector(onNewArrivalCart:) forControlEvents:UIControlEventTouchUpInside];
                            
                            [self.m_scrollView addPage:cardCell];
                            
                            [[GlobalData sharedGlobalData].g_autoFormat resizeView:cardCell];
                            
                        }
                    }
                    
                    [self.m_scrollView scrollToPageWithIndex:countLimit - 1 animated:NO];
                    
                } else {
                 
                    for (int i = 0; i < countLimit; i++) {
                        
                        NSDictionary* productInfo = products[i];
                        
                        if (productInfo) {
                            
                            ProductData *record = [[ProductData alloc] init];
                            record.productId = [productInfo objectForKey:KEY_ID];
                            record.name = [productInfo objectForKey:KEY_NAME];
                            record.price = [productInfo objectForKey:KEY_PRICE];
                            record.discount = [productInfo objectForKey:KEY_DISCOUNT];
                            record.productDescription = [productInfo objectForKey:KEY_DESCRIPTION];
                            record.image = [productInfo objectForKey:KEY_IMAGE];
                            record.percentage = [productInfo objectForKey:KEY_PERCENTAGE];
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
                            
                            [arrayNewArrival addObject:record];
                            
                            CardCellView* cardCell = [[[NSBundle mainBundle] loadNibNamed:@"CardCellView" owner:self options:nil] firstObject];
                            cardCell.m_view.layer.cornerRadius = 10.0f;
                            cardCell.m_imgProduct.layer.borderWidth = 5.0f;
                            cardCell.m_imgProduct.layer.borderColor = [UIColor lightGrayColor].CGColor;
                            
                            NSString *percentSymbol = @"%";
                            cardCell.m_lblOff.text = [NSString stringWithFormat:@"%@%@", record.percentage, percentSymbol];
                            
                            NSURL *imageURL = [NSURL URLWithString:record.image];
                            [cardCell.m_imgProduct setShowActivityIndicatorView:YES];
                            [cardCell.m_imgProduct setIndicatorStyle:UIActivityIndicatorViewStyleWhite];
                            [cardCell.m_imgProduct sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"loading"]];
                            
                            cardCell.m_lblName.text = record.name;
                            cardCell.m_lblDiscount.text = [self getFormattedPrice:record.discount];
                            
                            NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[self getFormattedPrice:record.price]];
                            [attributeString addAttribute:NSStrikethroughStyleAttributeName value:@1 range:NSMakeRange(0, [attributeString length])];
                            cardCell.m_lblPrice.attributedText = attributeString;
                            
                            if ([record.percentage isEqualToString:@"0"]) {
                                cardCell.m_viewOff.hidden = YES;
                                cardCell.m_lblPrice.hidden = YES;
                            } else {
                                cardCell.m_viewOff.hidden = NO;
                                cardCell.m_lblPrice.hidden = NO;
                            }
                            
                            [cardCell.m_btnNew addTarget:self action:@selector(onDetailView:) forControlEvents:UIControlEventTouchUpInside];
                            [cardCell.m_btnShare addTarget:self action:@selector(onNewArrivalShare:) forControlEvents:UIControlEventTouchUpInside];
                            [cardCell.m_btnCart addTarget:self action:@selector(onNewArrivalCart:) forControlEvents:UIControlEventTouchUpInside];
                            
                            [self.m_scrollView addPage:cardCell];
                            
                            [[GlobalData sharedGlobalData].g_autoFormat resizeView:cardCell];
                            
                        }
                    }
                }
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
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

- (void)onDetailView:(id)sender {
    
    [GlobalData sharedGlobalData].g_productData = [[ProductData alloc] init];
    [GlobalData sharedGlobalData].g_productData = arrayNewArrival[self.m_scrollView.pageControl.currentPage];
    
    AODetailsViewController *nextCtrl = [[self storyboard]instantiateViewControllerWithIdentifier:VIEW_DETAILS];
    [self.navigationController pushViewController:nextCtrl animated:true];
}

- (void)onNewArrivalShare:(id)sender {
    
    if ([[GlobalData sharedGlobalData].g_userInfo.language isEqualToString:LANGUAGE_ARABIAN]) {
        
        ProductData *record = [[ProductData alloc] init];
        record = arrayNewArrival[self.m_scrollView.pageControl.currentPage];
        
        int countIndex = [self isContainsProductToCart:record];
        
//        [self addProductToCart:record contains:countIndex];
        
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
        
        [self updateWishlistCartCount];
        
    } else {
        
        ProductData *record = [[ProductData alloc] init];
        record = arrayNewArrival[self.m_scrollView.pageControl.currentPage];
        
        NSString *strShareLink = [NSString stringWithFormat:@"%@%@", SHARE_URL, [record.url substringFromIndex:43]];
        
        NSURL *myWebsite = [NSURL URLWithString:strShareLink];
        NSArray* sharedObjects = @[myWebsite];
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:sharedObjects applicationActivities:nil];
        
        activityViewController.popoverPresentationController.sourceView = self.view;
        [self presentViewController:activityViewController animated:YES completion:nil];
    }
}

- (void)onNewArrivalCart:(id)sender {
    
    if ([[GlobalData sharedGlobalData].g_userInfo.language isEqualToString:LANGUAGE_ARABIAN]) {
        
        ProductData *record = [[ProductData alloc] init];
        record = arrayNewArrival[self.m_scrollView.pageControl.currentPage];
        
        NSString *strShareLink = [NSString stringWithFormat:@"%@%@", SHARE_URL, [record.url substringFromIndex:43]];
        
        NSURL *myWebsite = [NSURL URLWithString:strShareLink];
        NSArray* sharedObjects = @[myWebsite];
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:sharedObjects applicationActivities:nil];
        
        activityViewController.popoverPresentationController.sourceView = self.view;
        [self presentViewController:activityViewController animated:YES completion:nil];
        
    } else {
        
        ProductData *record = [[ProductData alloc] init];
        record = arrayNewArrival[self.m_scrollView.pageControl.currentPage];
        
        int countIndex = [self isContainsProductToCart:record];
        
//        [self addProductToCart:record contains:countIndex];
        
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
        
        [self updateWishlistCartCount];
    }
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

- (IBAction)onMoveLeft:(id)sender {
    
    if (countLimit > 0) {
        if (self.m_scrollView.pageControl.currentPage == 0) {
            
        } else {
            countNewArrival = (int)self.m_scrollView.pageControl.currentPage - 1;
            [self.m_scrollView scrollToPageWithIndex:countNewArrival animated:YES];
        }
    }
}

- (IBAction)onMoveRight:(id)sender {
 
    if (countLimit > 0) {
        if (self.m_scrollView.pageControl.currentPage == countLimit - 1) {
            
        } else {
            countNewArrival = (int)self.m_scrollView.pageControl.currentPage + 1;
            [self.m_scrollView scrollToPageWithIndex:countNewArrival animated:YES];
        }
    }
}

//------------- About --------------

- (IBAction)onAboutWorkingTime:(id)sender {
    
}

- (IBAction)onAboutShippingReturn:(id)sender {
    
    AOAboutViewController *nextCtrl = [[self storyboard]instantiateViewControllerWithIdentifier:VIEW_ABOUT];
    [self.navigationController pushViewController:nextCtrl animated:true];
}

- (IBAction)onAboutMoneyGuarantee:(id)sender {
    
}

- (IBAction)onAboutContactUs:(id)sender {
    
    AOContactUsViewController *nextCtrl = [[self storyboard]instantiateViewControllerWithIdentifier:VIEW_CONTACTUS];
    [self.navigationController pushViewController:nextCtrl animated:true];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* _cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    return _cell;
}

//------------ Unwind -----------------

- (IBAction)unwindPaymentConfirm:(UIStoryboardSegue *)unwindSegue {
    
    
}

- (IBAction)unwindLogout:(UIStoryboardSegue *)unwindSegue {
    
    
}

@end
