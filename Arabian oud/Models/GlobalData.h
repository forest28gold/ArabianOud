//
//  GlobalData.h
//  Arabian oud
//
//  Created by AppsCreationTech on 12/21/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "DataModel.h"
#import "DBHandler.h"
#import "AutoFormatter.h"
#import "UserData.h"
#import "AOMainViewController.h"
#import "ProductData.h"
#import "AddressData.h"
#import "OrderData.h"


@interface GlobalData : NSObject

@property (nonatomic, retain) AppDelegate                   *g_appDelegate;
@property (nonatomic, retain) DBHandler                     *g_dBHandler;
@property (nonatomic, retain) DataModel                     *g_dataModel;
@property (nonatomic, retain) AutoFormatter                 *g_autoFormat;
@property (nonatomic, retain) UserData                      *g_userInfo;
@property (nonatomic, retain) AOMainViewController          *g_mainCtrl;
@property (nonatomic, retain) ProductData                   *g_productData;
@property (nonatomic, retain) AddressData                   *g_addressData;
@property (nonatomic, retain) OrderData                     *g_orderData;

@property (strong, nonatomic) NSString                      *g_strCategory;
@property (strong, nonatomic) NSString                      *g_strCategoryID;
@property (strong, nonatomic) NSMutableArray                *g_arrayWishlist;
@property (strong, nonatomic) NSMutableArray                *g_arrayCart;
@property (nonatomic, assign) BOOL                          g_toggleProfileIsOn;
@property (strong, nonatomic) NSMutableArray                *g_arrayStoredAddresses;
@property (strong, nonatomic) NSMutableArray                *g_arrayOrder;
@property (strong, nonatomic) NSMutableArray                *g_arrayProduct;
@property (strong, nonatomic) NSMutableArray                *g_arrayStores;
@property (strong, nonatomic) NSString                      *g_strShippingAddress;
@property (strong, nonatomic) NSString                      *g_strCouponCode;
@property (nonatomic, assign) CGFloat                       g_discountPercent;

+ (GlobalData*)sharedGlobalData;

- (BOOL)checkingVaildateEmailWithString:(NSString *)strEmail;
- (NSString*)trimString:(NSString *)string;
- (NSDate*)dateFromString:(NSString *)strDate DateFormat:(NSString *)strDateFormat TimeZone:(NSTimeZone *)timeZone;
- (void)saveToUserDefaultsWithValue:(id)value Key:(NSString *)strKey;
- (id)userDefaultWithKey:(NSString *)strKey;
- (void)removeValueFromUserDefaults:(NSString *)strKey;

- (BOOL)isValidCheckDigitForCardNumberString:(NSString *)cardNumberString;

- (UIImage*)imageWithColor:(UIColor *)color;
- (UIColor*)colorWithHexString:(NSString *)colorString;

- (NSString*)getCurrentDate;
- (void)onErrorAlert:(NSString*)errorString;

@end
