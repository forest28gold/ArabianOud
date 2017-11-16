//
//  APIManager.m
//  Arabian oud
//
//  Created by AppsCreationTech on 12/26/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import "APIManager.h"

@interface APIManager ()

@property (strong, nonatomic) NSString* lyftAccessToken;

@end

@implementation APIManager

+ (APIManager*)sharedManager {
    
    static APIManager* _sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

+ (NSString*)base64EncodedStringFromString:(NSString*)string {
    NSData *data = [NSData dataWithBytes:[string UTF8String] length:[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    NSUInteger length = [data length];
    NSMutableData *mutableData = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    
    uint8_t *input = (uint8_t *)[data bytes];
    uint8_t *output = (uint8_t *)[mutableData mutableBytes];
    
    for (NSUInteger i = 0; i < length; i += 3) {
        NSUInteger value = 0;
        for (NSUInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        static uint8_t const kAFBase64EncodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        
        NSUInteger idx = (i / 3) * 4;
        output[idx + 0] = kAFBase64EncodingTable[(value >> 18) & 0x3F];
        output[idx + 1] = kAFBase64EncodingTable[(value >> 12) & 0x3F];
        output[idx + 2] = (i + 1) < length ? kAFBase64EncodingTable[(value >> 6)  & 0x3F] : '=';
        output[idx + 3] = (i + 2) < length ? kAFBase64EncodingTable[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:mutableData encoding:NSASCIIStringEncoding];
}

- (AFHTTPRequestOperationManager*)operationManager {
    
    AFHTTPRequestOperationManager* operationManager = [AFHTTPRequestOperationManager manager];
    
    // test code to mark json format
    operationManager.responseSerializer = [AFJSONResponseSerializer serializer];
//    operationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [operationManager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:
//                                                                    @"application/x-www-form-urlencoded",
//                                                                    @"application/json",
//                                                                    @"text/plain",
//                                                                    @"text/html",
//                                                                    nil]];
    
    //    if (self.apiToken)
    //        [operationManager.requestSerializer setValue:self.apiToken forHTTPHeaderField:key_apitoken];
    
    return operationManager;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
    }
    
    return self;
}

- (NSString*)jsonStringWithJsonDict:(NSDictionary*)jsonDict {
    NSString* jsonString = @"";
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:kNilOptions error:nil];
    if (jsonData)
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString;
}

- (void)getCategoryProducts:(NSString *)categoryTag
                  productId:(NSString *)productId
                    startId:(NSString *)startId
                   language:(NSString *)language
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{KEY_TAG: categoryTag,
                             KEY_ID: productId,
                             KEY_START_ID: startId,
                             KEY_LANGUAGE: language
                             };
    
    AFHTTPRequestOperationManager* operationManager = [self operationManager];
    [operationManager GET:SHOP_ARABIANOUD_URL parameters:params success:success failure:failure];
}

- (void)searchAllProducts:(NSString *)categoryTag
                productId:(NSString *)productId
                  startId:(NSString *)startId
                searchKey:(NSString *)searchKey
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{KEY_TAG: categoryTag,
                             KEY_ID: productId,
                             KEY_START_ID: startId,
                             KEY_SEARCH_KEY: searchKey
                             };
    
    AFHTTPRequestOperationManager* operationManager = [self operationManager];
    [operationManager GET:SHOP_ARABIANOUD_URL parameters:params success:success failure:failure];
    
}

- (void)loginArabian:(NSString *)loginTag
               email:(NSString *)email
            password:(NSString *)password
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{KEY_TAG: loginTag,
                             KEY_EMAIL: email,
                             KEY_PASSWORD: password
                             };
    
    AFHTTPRequestOperationManager* operationManager = [self operationManager];
    [operationManager GET:SHOP_ARABIANOUD_URL parameters:params success:success failure:failure];
}

- (void)signupArabian:(NSString *)registerTag
            firstName:(NSString *)firstName
             lastName:(NSString *)lastName
                email:(NSString *)email
             password:(NSString *)password
              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{KEY_TAG: registerTag,
                             KEY_FIRST_NAME: firstName,
                             KEY_LAST_NAME: lastName,
                             KEY_EMAIL: email,
                             KEY_PASSWORD: password
                             };
    
    AFHTTPRequestOperationManager* operationManager = [self operationManager];
    [operationManager GET:SHOP_ARABIANOUD_URL parameters:params success:success failure:failure];
}

- (void)forgotPassword:(NSString *)passwordTag
                 email:(NSString *)email
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{KEY_TAG: passwordTag,
                             KEY_EMAIL: email
                             };
    
    AFHTTPRequestOperationManager* operationManager = [self operationManager];
    [operationManager GET:SHOP_ARABIANOUD_RESET_PASSWORD_URL parameters:params success:success failure:failure];
}

- (void)getAllAddresses:(NSString *)allAddressesTag
                  email:(NSString *)email
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{KEY_TAG: allAddressesTag,
                             KEY_EMAIL: email
                             };
    
    AFHTTPRequestOperationManager* operationManager = [self operationManager];
    [operationManager GET:SHOP_ARABIANOUD_URL parameters:params success:success failure:failure];
}

- (void)getStoreLocations:(NSString *)locationTag
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{KEY_TAG: locationTag
                             };
    
    AFHTTPRequestOperationManager* operationManager = [self operationManager];
    [operationManager GET:SHOP_ARABIANOUD_URL parameters:params success:success failure:failure];
}

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
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{KEY_TAG: setDefaultShippingBillingAddressTag,
                             KEY_EMAIL: email,
                             KEY_IS_DEFAULT: isDefault,
                             KEY_FNAME: fname,
                             KEY_LNAME: lname,
                             KEY_STNAME: stname,
                             KEY_STNUM: stnum,
                             KEY_ADDINFO: addinfo,
                             KEY_CITY: city,
                             KEY_COMPANY: company,
                             KEY_ZIP: zip,
                             KEY_COUNTRY: country,
                             KEY_TEL: tel,
                             KEY_FAX: fax
                             };
    
    AFHTTPRequestOperationManager* operationManager = [self operationManager];
    [operationManager GET:SHOP_ARABIANOUD_URL parameters:params success:success failure:failure];
}

- (void)addToCart:(NSString *)addToCartTag
              ids:(NSString *)ids
             qtys:(NSString *)qtys
            email:(NSString *)email
          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{KEY_TAG: addToCartTag,
                             KEY_IDS: ids,
                             KEY_QTYS: qtys,
                             KEY_EMAIL: email
                             };
    
    AFHTTPRequestOperationManager* operationManager = [self operationManager];
    [operationManager GET:SHOP_ARABIANOUD_URL parameters:params success:success failure:failure];
}

- (void)deleteCart:(NSString *)deleteCartTag
             email:(NSString *)email
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{KEY_TAG: deleteCartTag,
                             KEY_EMAIL: email
                             };
    
    AFHTTPRequestOperationManager* operationManager = [self operationManager];
    [operationManager GET:SHOP_ARABIANOUD_URL parameters:params success:success failure:failure];
}

- (void)checkout:(NSString *)checkoutTag
           email:(NSString *)email
           total:(NSString *)total
         address:(NSString *)address
      couponCode:(NSString *)couponCode
         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{KEY_TAG: checkoutTag,
                             KEY_EMAIL: email,
                             KEY_TOTAL: total,
                             KEY_ADDRESS: address,
                             KEY_COUPON_CODE: couponCode
                             };
    
    AFHTTPRequestOperationManager* operationManager = [self operationManager];
    [operationManager GET:SHOP_ARABIANOUD_URL parameters:params success:success failure:failure];
}

- (void)checkoutBankTransfer:(NSString *)bankTransferTag
                       email:(NSString *)email
                       total:(NSString *)total
                     address:(NSString *)address
                  couponCode:(NSString *)couponCode
                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{KEY_TAG: bankTransferTag,
                             KEY_EMAIL: email,
                             KEY_TOTAL: total,
                             KEY_ADDRESS: address,
                             KEY_COUPON_CODE: couponCode
                             };
    
    AFHTTPRequestOperationManager* operationManager = [self operationManager];
    [operationManager GET:SHOP_ARABIANOUD_URL parameters:params success:success failure:failure];
}

- (void)checkoutPaypal:(NSString *)paypalTag
                 email:(NSString *)email
                 total:(NSString *)total
               address:(NSString *)address
            couponCode:(NSString *)couponCode
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{KEY_TAG: paypalTag,
                             KEY_EMAIL: email,
                             KEY_TOTAL: total,
                             KEY_ADDRESS: address,
                             KEY_COUPON_CODE: couponCode
                             };
    
    AFHTTPRequestOperationManager* operationManager = [self operationManager];
    [operationManager GET:SHOP_ARABIANOUD_URL parameters:params success:success failure:failure];
}

- (void)checkoutGatePlay:(NSString *)creditCardTag
                   email:(NSString *)email
                   total:(NSString *)total
                 address:(NSString *)address
              couponCode:(NSString *)couponCode
                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{KEY_TAG: creditCardTag,
                             KEY_EMAIL: email,
                             KEY_TOTAL: total,
                             KEY_ADDRESS: address,
                             KEY_COUPON_CODE: couponCode
                             };
    
    AFHTTPRequestOperationManager* operationManager = [self operationManager];
    [operationManager GET:SHOP_ARABIANOUD_URL parameters:params success:success failure:failure];
}

- (void)setCouponCode:(NSString *)setCouponCodeTag
           couponCode:(NSString *)couponCode
              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{KEY_TAG: setCouponCodeTag,
                             KEY_COUPON_CODE: couponCode
                             };
    
    AFHTTPRequestOperationManager* operationManager = [self operationManager];
    [operationManager GET:SHOP_ARABIANOUD_URL parameters:params success:success failure:failure];
}

- (void)creditcardCheckout:(NSString *)creditcardCheckoutTag
                    amount:(NSString *)amount
                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSDictionary* params = @{KEY_TAG: creditcardCheckoutTag,
                             KEY_AMOUNT: amount
                             };
    
    AFHTTPRequestOperationManager* operationManager = [self operationManager];
    [operationManager GET:SHOP_ARABIANOUD_URL parameters:params success:success failure:failure];
}

@end
