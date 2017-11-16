//
// Copyright (c) 2016 by ACI Worldwide, Inc.
// All rights reserved.
//
// This software is the confidential and proprietary information
// of ACI Worldwide Inc ("Confidential Information"). You shall
// not disclose such Confidential Information and shall use it
// only in accordance with the terms of the license agreement
// you entered with ACI Worldwide Inc.
//

#import <OPPWAMobile/OPPWAMobile.h>

/**
 Class to encapsulate all necessary transaction parameters for performing a token transaction.
 */

NS_ASSUME_NONNULL_BEGIN
@interface OPPTokenPaymentParams : OPPPaymentParams

/** @name Initialization methods */

/**
 Creates an object representing a token transaction.
 
 @param checkoutID The checkout ID of the transaction. Must be not nil or empty.
 @param tokenID The identifier of the token that can be used to reference the token later.
 @param brand Payment method brand. Parameter is optional and can be set to OPPPaymentParamsBrandUnknown.
 @param error The error that occurred while validating payment parameters. See code attribute (OPPErrorCode) and NSLocalizedDescription to identify the reason of failure.
 @return Returns an object representing a token transaction, and nil if parameters are invalid.
 */
+ (nullable instancetype)tokenPaymentParamsWithCheckoutID:(NSString *)checkoutID tokenID:(NSString *)tokenID brand:(OPPPaymentParamsBrand)brand error:(NSError **)error;

/**
 Creates an object representing a token transaction.
 
 @param checkoutID The checkout ID of the transaction. Must be not nil or empty.
 @param tokenID The identifier of the token that can be used to reference the token later.
 @param cardBrand The brand of the tokenized card.
 @param CVV The CVV code found on the card.
 @param error The error that occurred while validating payment parameters. See code attribute (OPPErrorCode) and NSLocalizedDescription to identify the reason of failure.
 @return Returns an object representing a token transaction, and nil if parameters are invalid.
 */
+ (nullable instancetype)tokenPaymentParamsWithCheckoutID:(NSString *)checkoutID tokenID:(NSString *)tokenID cardBrand:(OPPPaymentParamsBrand)cardBrand CVV:(nullable NSString *)CVV error:(NSError **)error;

/**
 Creates an object representing a token transaction.
 
 @param checkoutID The checkout ID of the transaction. Must be not nil or empty.
 @param tokenID The identifier of the token that can be used to reference the token later.
 @param brand Payment method brand. Parameter is optional and can be set to OPPPaymentParamsBrandUnknown.
 @param error The error that occurred while validating payment parameters. See code attribute (OPPErrorCode) and NSLocalizedDescription to identify the reason of failure.
 @return Returns an object representing a token transaction, and nil if parameters are invalid.
 */
- (nullable instancetype)initWithCheckoutID:(NSString *)checkoutID tokenID:(NSString *)tokenID brand:(OPPPaymentParamsBrand)brand error:(NSError **)error NS_DESIGNATED_INITIALIZER;

/**
 Creates an object representing a token transaction.
 
 @param checkoutID The checkout ID of the transaction. Must be not nil or empty.
 @param tokenID The identifier of the token that can be used to reference the token later.
 @param cardBrand The brand of the tokenized card.
 @param CVV The CVV code found on the card.
 @param error The error that occurred while validating payment parameters. See code attribute (OPPErrorCode) and NSLocalizedDescription to identify the reason of failure.
 @return Returns an object representing a token transaction, and nil if parameters are invalid.
 */
- (nullable instancetype)initWithCheckoutID:(NSString *)checkoutID tokenID:(NSString *)tokenID cardBrand:(OPPPaymentParamsBrand)cardBrand CVV:(nullable NSString *)CVV error:(NSError **)error NS_DESIGNATED_INITIALIZER;

/** @name Properties */

/**
 The identifier of the token that can be used to reference the token later.
 */
@property (nonatomic, copy, readonly) NSString *tokenID;

/**
 The CVV code found on the card. Property should be set, if CVV check is required for transaction processing.
 */
@property (nonatomic, copy, readonly, nullable) NSString *CVV;

/** @name Validation methods */
/**
 Checks if the token identifier is valid to perform a transaction.
 
 @param tokenID The identifier of the token that can be used to reference the token later.
 @return YES if token identifier is alpha-numeric string of length 32.
 */
+ (BOOL)isTokenIDValid:(NSString *)tokenID;

/**
 Checks if the card CVV is filled with sufficient data to perform a transaction.
 
 @param CVV The card security code or CVV.
 @param brand The brand of the tokenized card.
 @return YES if the card CVV length greater than 3 characters and less than 4 characters, it's also valid for nil value, because it's optional parameter.
 */
+ (BOOL)isCvvValid:(NSString *)CVV forBrand:(OPPPaymentParamsBrand)brand;

@end
NS_ASSUME_NONNULL_END
