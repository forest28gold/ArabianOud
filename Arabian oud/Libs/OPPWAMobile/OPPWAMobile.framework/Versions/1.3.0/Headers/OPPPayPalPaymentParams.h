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
 Class to encapsulate all necessary transaction parameters for performing a PayPal transaction.
 */

NS_ASSUME_NONNULL_BEGIN
@interface OPPPayPalPaymentParams : OPPPaymentParams

/** @name Initialization methods */

/**
 Creates an object representing a PayPal transaction.
 
 @param checkoutID The checkout ID of the transaction. Must be not nil or empty.
 @param error The error that occurred while validating payment parameters. See code attribute (OPPErrorCode) and NSLocalizedDescription to identify the reason of failure.
 @return Returns an object representing a PayPal transaction.
 */
+ (nullable instancetype)payPalPaymentParamsWithCheckoutID:(NSString *)checkoutID error:(NSError **)error;

/**
 Creates an object representing a PayPal transaction.
 
 @param checkoutID The checkout ID of the transaction. Must be not nil or empty.
 @param error The error that occurred while validating payment parameters. See code attribute (OPPErrorCode) and NSLocalizedDescription to identify the reason of failure.
 @return Returns an object representing a PayPal transaction.
 */
- (nullable instancetype)initWithCheckoutID:(NSString *)checkoutID error:(NSError **)error NS_DESIGNATED_INITIALIZER;
@end
NS_ASSUME_NONNULL_END

