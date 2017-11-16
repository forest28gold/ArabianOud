//
//  AODetailsViewController.m
//  Arabian oud
//
//  Created by AppsCreationTech on 12/26/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import "AODetailsViewController.h"
#import "AOWishlistViewController.h"
#import "AOCartViewController.h"
#import "DetailsView.h"
#import "AODetailsTableViewCell.h"
#import "AOCartViewController.h"

#import <MessageUI/MFMailComposeViewController.h>
#import <Social/Social.h>

static NSString *AODetailsTableViewCellIdentifier = @"AODetailsTableViewCellIdentifier";

@interface AODetailsViewController () <MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *detailsArray;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) DetailsView *detailsView;

@end

@implementation AODetailsViewController

@synthesize m_lblTitle, m_lblProductName;
@synthesize m_btnCart, m_btnWishlist;
@synthesize m_tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    m_lblTitle.text = [GlobalData sharedGlobalData].g_productData.name;
    m_lblProductName.text = [GlobalData sharedGlobalData].g_productData.name;
    
    self.detailsArray = [[NSMutableArray alloc] init];
    
    NSArray *titleArray = [NSArray arrayWithObjects:NSLocalizedString(@"detail_description", ""), NSLocalizedString(@"detail_sku", ""), NSLocalizedString(@"detail_size", ""), NSLocalizedString(@"detail_type", ""), NSLocalizedString(@"detail_origins", ""), NSLocalizedString(@"detail_fragrance", ""), nil];
    
    NSArray *contentArray = [NSArray arrayWithObjects:[GlobalData sharedGlobalData].g_productData.productDescription, [GlobalData sharedGlobalData].g_productData.sku, [GlobalData sharedGlobalData].g_productData.size, [GlobalData sharedGlobalData].g_productData.type, [GlobalData sharedGlobalData].g_productData.origin, [GlobalData sharedGlobalData].g_productData.fragrance, nil];
    
    for (int i = 0; i < titleArray.count; i++) {
        
        DetailsData *record = [[DetailsData alloc] init];
        record.title = titleArray[i];
        record.details = contentArray[i];
        
        [self.detailsArray addObject:record];
    }
    
    [self initLoadHeaderView];
    [m_tableView registerClass:[AODetailsTableViewCell class] forCellReuseIdentifier:AODetailsTableViewCellIdentifier];
    
    [[GlobalData sharedGlobalData].g_autoFormat resizeView:self.view];
    
    if ([[GlobalData sharedGlobalData].g_userInfo.language isEqualToString:LANGUAGE_ARABIAN]) {
        
        m_btnCart.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        m_btnCart.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        m_btnCart.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        
        m_btnWishlist.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        m_btnWishlist.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        m_btnWishlist.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    }
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

- (void)updateWishlistCartCount {
    
    [m_btnWishlist setTitle:[NSString stringWithFormat:@"%i", (int)[GlobalData sharedGlobalData].g_arrayWishlist.count] forState:UIControlStateNormal];
    [m_btnCart setTitle:[NSString stringWithFormat:@"%i", (int)[GlobalData sharedGlobalData].g_arrayCart.count] forState:UIControlStateNormal];
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

- (void)initLoadHeaderView {
    
    self.detailsView = [[[NSBundle mainBundle] loadNibNamed:@"DetailsView" owner:self options:nil] firstObject];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCloseShareView)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    self.detailsView.m_viewShare.hidden = YES;
    self.detailsView.m_lblCost.text = [self getFormattedPrice:[GlobalData sharedGlobalData].g_productData.discount];
    
    NSURL *imageURL = [NSURL URLWithString:[GlobalData sharedGlobalData].g_productData.image];
    [self.detailsView.m_imgProduct setShowActivityIndicatorView:YES];
    [self.detailsView.m_imgProduct setIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.detailsView.m_imgProduct sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"icon-1024"]];
    
    [self.detailsView.m_btnShare addTarget:self action:@selector(onShare:) forControlEvents:UIControlEventTouchUpInside];
    [self.detailsView.m_btnShareFacebook addTarget:self action:@selector(onShareFacebook:) forControlEvents:UIControlEventTouchUpInside];
    [self.detailsView.m_btnShareTwitter addTarget:self action:@selector(onShareTwitter:) forControlEvents:UIControlEventTouchUpInside];
    [self.detailsView.m_btnSharePinterest addTarget:self action:@selector(onSharePinterest:) forControlEvents:UIControlEventTouchUpInside];
    [self.detailsView.m_btnShareWhatsapp addTarget:self action:@selector(onShareWhatsapp:) forControlEvents:UIControlEventTouchUpInside];
    [self.detailsView.m_btnShareEmail addTarget:self action:@selector(onShareEmail:) forControlEvents:UIControlEventTouchUpInside];
    [self.detailsView.m_btnBuynow addTarget:self action:@selector(onSelectBuyNow:) forControlEvents:UIControlEventTouchUpInside];
    [self.detailsView.m_btnCart addTarget:self action:@selector(onSelectCart:) forControlEvents:UIControlEventTouchUpInside];
    [self.detailsView.m_btnWishlist addTarget:self action:@selector(onSelectWishlist:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.detailsView.m_btnBuynow setTitle:NSLocalizedString(@"button_buy_now", "") forState:UIControlStateNormal];
    [self.detailsView.m_btnCart setTitle:NSLocalizedString(@"button_cart", "") forState:UIControlStateNormal];
    [self.detailsView.m_btnWishlist setTitle:NSLocalizedString(@"button_wishlist", "") forState:UIControlStateNormal];
    
    if ([[GlobalData sharedGlobalData].g_userInfo.language isEqualToString:LANGUAGE_ARABIAN]) {
        
        self.detailsView.m_btnCart.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        self.detailsView.m_btnCart.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        self.detailsView.m_btnCart.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        
        self.detailsView.m_btnWishlist.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        self.detailsView.m_btnWishlist.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        self.detailsView.m_btnWishlist.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        
        self.detailsView.m_lblCost.textAlignment = NSTextAlignmentRight;
    }
    
    m_tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, m_tableView.frame.size.width, 390)];
    [m_tableView.tableHeaderView addSubview:self.detailsView];
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

- (void)showAnimationView:(UIView *)mView {
    
    mView.hidden = NO;
    mView.alpha = 0;
    [UIView animateWithDuration:.3 animations:^{
        mView.alpha = 1;
    } completion:^(BOOL finished) {
        if (finished) {
            
        }
    }];
}

- (void)closeAnimationView:(UIView *)mView {
    
    mView.hidden = YES;
    [UIView animateWithDuration:.3 animations:^{
        mView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {

        }
    }];
}

- (void)onCloseShareView {
    [self closeAnimationView:self.detailsView.m_viewShare];
}

//------------ Share ----------------

- (void)onShare:(id)sender {
    [self showAnimationView:self.detailsView.m_viewShare];
}

- (void)onShareFacebook:(id)sender {
    
    [self onCloseShareView];
    
    NSString *strShareLink = [NSString stringWithFormat:@"%@%@", SHARE_URL, [[GlobalData sharedGlobalData].g_productData.url substringFromIndex:43]];
    
    [self shareToSicial:0 viewCtrl:self image:[UIImage imageNamed:@"icon-512"] text:strShareLink];
}

- (void)onShareTwitter:(id)sender {
    
    [self onCloseShareView];
    
    NSString *strShareLink = [NSString stringWithFormat:@"%@%@", SHARE_URL, [[GlobalData sharedGlobalData].g_productData.url substringFromIndex:43]];
    
    [self shareToSicial:1 viewCtrl:self image:[UIImage imageNamed:@"icon-512"] text:strShareLink];
}

- (void)shareToSicial:(NSInteger)type viewCtrl:(UIViewController*)viewController image:(UIImage*)image text:(NSString*)shareLink {
    
    switch (type) {
        case 0: // FB
            
            if ( [SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook] ) {
                SLComposeViewController* fbSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                
//                [fbSheet addImage:image];
                [fbSheet setInitialText:shareLink];
                
                [viewController presentViewController:fbSheet animated:true completion:nil];
            }
            
            break;
        case 1: // Twitter
            if ( [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter] ) {
                SLComposeViewController* twSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                
//                [twSheet addImage:image];
                [twSheet setInitialText:shareLink];
                
                [viewController presentViewController:twSheet animated:true completion:nil];
            }
            break;
        default:
            break;
    }
}

- (void)onSharePinterest:(id)sender {
    
    [self onCloseShareView];
    
    NSString *strShareLink = [NSString stringWithFormat:@"%@%@", SHARE_URL, [[GlobalData sharedGlobalData].g_productData.url substringFromIndex:43]];
    NSURL *imageURL = [NSURL URLWithString:[GlobalData sharedGlobalData].g_productData.image];
    
    NSString * urlPin = [NSString stringWithFormat:@"pinit12://pinterest.com/pin/create/bookmarklet/?url=%@&media=%@&description=%@\"", strShareLink, imageURL, @""];
    NSURL * pinterestURL = [NSURL URLWithString:[urlPin stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"pinterest://"]]) {
        [[UIApplication sharedApplication] openURL:pinterestURL];
    } else {
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_device_not_install_pinterest", "")];
    }
}

- (void)onShareWhatsapp:(id)sender {
    
    [self onCloseShareView];
    
    NSString *strShareLink = [NSString stringWithFormat:@"%@%@", SHARE_URL, [[GlobalData sharedGlobalData].g_productData.url substringFromIndex:43]];

    NSString * urlWhats = [NSString stringWithFormat:@"whatsapp://send?text=%@", strShareLink];
    NSURL * whatsappURL = [NSURL URLWithString:[urlWhats stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"whatsapp://app"]]) {
        [[UIApplication sharedApplication] openURL:whatsappURL];
    } else {
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_device_not_install_whatsapp", "")];
    }
}

- (void)onShareEmail:(id)sender {
    
    [self onCloseShareView];
    
    NSString *strShareLink = [NSString stringWithFormat:@"%@%@", SHARE_URL, [[GlobalData sharedGlobalData].g_productData.url substringFromIndex:43]];
    
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        [mailController setToRecipients:nil];
        [mailController setSubject:@""];
        [mailController setMessageBody:strShareLink isHTML:NO];
        mailController.mailComposeDelegate = self;
        [self presentViewController:mailController animated:YES completion:nil];
    } else {
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_cant_send_message", "")];
        return;
    }
}

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error;
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_email_cancelled", "")];
            break;
        case MFMailComposeResultSaved:
            [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_email_saved", "")];
            break;
        case MFMailComposeResultSent:
            [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_email_sent", "")];
            break;
        case MFMailComposeResultFailed:
            [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_email_failed", "")];
            break;
        default:
            [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_email_not_sent", "")];
            break;
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

//------------ Buy now --------------

- (void)onSelectBuyNow:(id)sender {
    
    [self onCloseShareView];
    
    int countIndex = [self isContainsProductToCart:[GlobalData sharedGlobalData].g_productData];
    
    ProductData *record = [GlobalData sharedGlobalData].g_productData;
    
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
    
    [self updateWishlistCartCount];
    
    AOCartViewController *nextCtrl = [[self storyboard]instantiateViewControllerWithIdentifier:VIEW_CART];
    [self.navigationController pushViewController:nextCtrl animated:true];
}

- (void)onSelectCart:(id)sender {
    
    [self onCloseShareView];
    
    [self.view makeToast:NSLocalizedString(@"item_added_to_cart", "") duration:1.0 position:CSToastPositionBottom];
    
    int countIndex = [self isContainsProductToCart:[GlobalData sharedGlobalData].g_productData];
    
    ProductData *record = [GlobalData sharedGlobalData].g_productData;
    
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
    
    [self updateWishlistCartCount];
}

- (void)onSelectWishlist:(id)sender {
    
    [self onCloseShareView];
    
    [self.view makeToast:NSLocalizedString(@"item_added_to_wishlist", "") duration:1.0 position:CSToastPositionBottom];
    
    if (![self isContainsProductToWishlist:[GlobalData sharedGlobalData].g_productData]) {
        
        [[GlobalData sharedGlobalData].g_arrayWishlist addObject:[GlobalData sharedGlobalData].g_productData];
        [[GlobalData sharedGlobalData].g_dataModel insertWishlistDataDB:[GlobalData sharedGlobalData].g_productData];
        
        [self updateWishlistCartCount];
    }
}

- (BOOL)isContainsProductToWishlist:(ProductData*)product{
    
    for (int i = 0; i < [GlobalData sharedGlobalData].g_arrayWishlist.count; i++) {
        
        ProductData *record = [GlobalData sharedGlobalData].g_arrayWishlist[i];
        if ([record.productId isEqualToString:product.productId]) {
            return true;
        }
    }
    
    return false;
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

//-------------

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.detailsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AODetailsTableViewCell *cell = (AODetailsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:AODetailsTableViewCellIdentifier forIndexPath:indexPath];
    
    DetailsData *record = self.detailsArray[indexPath.row];
    
    [cell setupCellWithData:record];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakSelf = self;
    CGSize defaultSize = DEFAULT_CELL_SIZE;
    
    DetailsData *record = weakSelf.detailsArray[indexPath.row];
    
    CGSize cellSize = [AODetailsTableViewCell sizeForCellWithDefaultSize:defaultSize setupCellBlock:^id(id<HTKDynamicResizingCellProtocol> cellToSetup) {
        
        [((AODetailsTableViewCell *)cellToSetup) setupCellWithData:record];
        
        return cellToSetup;
    }];
    return cellSize.height;    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
