//
//  APIManager.h
//  Arabian oud
//
//  Created by AppsCreationTech on 12/26/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIManager : NSObject

+ (APIManager*)sharedManager;
- (AFHTTPRequestOperationManager*)operationManager;

- (instancetype)init;

- (void)getCategoryProducts:(NSString *)categoryTag
                  productId:(NSString *)productId
                    startId:(NSString *)startId
                   language:(NSString *)language
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)searchAllProducts:(NSString *)categoryTag
                productId:(NSString *)productId
                  startId:(NSString *)startId
                searchKey:(NSString *)searchKey
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)loginArabian:(NSString *)loginTag
               email:(NSString *)email
            password:(NSString *)password
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)signupArabian:(NSString *)registerTag
            firstName:(NSString *)firstName
             lastName:(NSString *)lastName
                email:(NSString *)email
             password:(NSString *)password
              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)forgotPassword:(NSString *)passwordTag
                 email:(NSString *)email
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)getAllAddresses:(NSString *)allAddressesTag
                 email:(NSString *)email
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)getStoreLocations:(NSString *)locationTag
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)addShippingBillingAddress:(NSString *)setDefaultShippingBillingAddressTag
                            email:(NSString *)email
                        isDefault:(NSString *)isDefault
                            fname:(NSString *)fname
                            lname:(NSString *)lname
                           stname:(NSString *)stname
                            stnum:(NSString *)stnum
                          addinfo:(NSString *)addinfo
                             city:(NSString *)city
                          company:(NSString *)company
                              zip:(NSString *)zip
                          country:(NSString *)country
                              tel:(NSString *)tel
                              fax:(NSString *)fax
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)addToCart:(NSString *)addToCartTag
              ids:(NSString *)ids
             qtys:(NSString *)qtys
            email:(NSString *)email
          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)deleteCart:(NSString *)deleteCartTag
             email:(NSString *)email
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)checkout:(NSString *)checkoutTag
           email:(NSString *)email
           total:(NSString *)total
         address:(NSString *)address
      couponCode:(NSString *)couponCode
         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)checkoutBankTransfer:(NSString *)bankTransferTag
                       email:(NSString *)email
                       total:(NSString *)total
                     address:(NSString *)address
                  couponCode:(NSString *)couponCode
                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)checkoutPaypal:(NSString *)paypalTag
                 email:(NSString *)email
                 total:(NSString *)total
               address:(NSString *)address
            couponCode:(NSString *)couponCode
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)checkoutGatePlay:(NSString *)creditCardTag
                   email:(NSString *)email
                   total:(NSString *)total
                 address:(NSString *)address
              couponCode:(NSString *)couponCode
                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)setCouponCode:(NSString *)setCouponCodeTag
           couponCode:(NSString *)couponCode
              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)creditcardCheckout:(NSString *)creditcardCheckoutTag
                    amount:(NSString *)amount
                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
