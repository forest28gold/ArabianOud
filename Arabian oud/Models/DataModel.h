//
//  DataModel.h
//  Arabian oud
//
//  Created by AppsCreationTech on 12/21/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#import "ProductData.h"
#import "OrderData.h"

#define TABLE_USER                      @"arabianoud_user"

#define FIELD_USER_ID                   @"userID"
#define FIELD_FIRST_NAME                @"firstname"
#define FIELD_LAST_NAME                 @"lastname"
#define FIELD_EMAIL                     @"email"
#define FIELD_PASSWORD                  @"password"
#define FIELD_ADDRESS                   @"address"
#define FIELD_TELEPHONE                 @"telephone"
#define FIELD_LANGUAGE                  @"language"
#define FIELD_SIGNUP                    @"signup"

#define TABLE_WISHLIST                  @"arabianoud_wishlist"
#define TABLE_CART                      @"arabianoud_cart"
#define TABLE_PRODUCT                   @"arabianoud_product"

#define FIELD_PRODUCT_ID                @"productId"
#define FIELD_NAME                      @"name"
#define FIELD_PRICE                     @"price"
#define FIELD_DISCOUNT                  @"discount"
#define FIELD_DESCRIPTION               @"productDescription"
#define FIELD_IMAGE                     @"image"
#define FIELD_PERCENTAGE                @"percentage"
#define FIELD_URL                       @"url"
#define FIELD_SKU                       @"sku"
#define FIELD_SIZE                      @"size"
#define FIELD_TYPE                      @"type"
#define FIELD_ORIGIN                    @"origin"
#define FIELD_FRAGRANCE                 @"fragrance"
#define FIELD_COUNT                     @"count"

#define TABLE_ORDER                     @"arabianoud_order"

#define FIELD_ORDER_ID                  @"orderId"
#define FIELD_DATE                      @"date"
#define FIELD_SHIP                      @"ship"
#define FIELD_TOTAL                     @"total"
#define FIELD_TYPE                      @"type"
#define FIELD_COUPON_CODE               @"couponCode"
#define FIELD_DISCOUNT_PERCENT          @"discountPercent"


@interface DataModel : NSObject

@property (nonatomic) sqlite3 *dbHandler;

+ (BOOL)createTable:(sqlite3 *)dbHandler;
- (id)initWithDBHandler:(sqlite3*)dbHandler;
- (BOOL)updateUserDB;

- (BOOL)onLoadWishlistDataDB;
- (BOOL)insertWishlistDataDB:(ProductData*)record;
- (BOOL)deleteWishlistDataDB:(ProductData*)record;
- (BOOL)deleteAllWishlistDataDB;
- (BOOL)updateNoneWishlistDataDB;

- (BOOL)onLoadCartDataDB;
- (BOOL)insertCartDataDB:(ProductData*)record;
- (BOOL)deleteCartDataDB:(ProductData*)record;
- (BOOL)updateCartDataDB:(ProductData*)record;
- (BOOL)deleteAllCartDataDB;
- (BOOL)updateNoneCartDataDB;

- (BOOL)onLoadOrderDataDB;
- (BOOL)insertOrderDataDB:(OrderData*)record;

- (BOOL)onLoadProductDataDB:(NSString*)strOrderId;
- (BOOL)insertProductDataDB:(NSMutableArray*)productArray orderId:(NSString*)strOrderId;

@end
