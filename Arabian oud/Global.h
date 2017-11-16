//
//  Global.h
//  Arabian oud
//
//  Created by AppsCreationTech on 12/21/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//


#ifndef Arabianoud_Global_h
#define Arabianoud_Global_h

#define SCREEN_WIDTH                                                [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT                                               [UIScreen mainScreen].bounds.size.height

#define VIEW_SELECT_REGION                                          @"AOSelectRegionViewController"
#define VIEW_MAIN                                                   @"AOMainViewController"
#define VIEW_MENU                                                   @"AOMenuViewController"
#define VIEW_MENU_AR                                                @"AOMenuARViewController"
#define VIEW_ABOUT                                                  @"AOAboutViewController"
#define VIEW_STORES_LOCATION                                        @"AOStoresLocationViewController"
#define VIEW_CONTACTUS                                              @"AOContactUsViewController"
#define VIEW_PROFILE                                                @"AOProfileViewController"
#define VIEW_ORDERS                                                 @"AOOrdersViewController"

#define VIEW_LOGIN                                                  @"AOLoginViewController"
#define VIEW_SIGNUP                                                 @"AOSignupViewController"
#define VIEW_FORGOT_PASSWORD                                        @"AOForgotPasswordViewController"

#define VIEW_CATEGORY                                               @"AOCategoryViewController"
#define VIEW_WISHLIST                                               @"AOWishlistViewController"
#define VIEW_CART                                                   @"AOCartViewController"
#define VIEW_SEARCH                                                 @"AOSearchViewController"
#define VIEW_DETAILS                                                @"AODetailsViewController"

#define VIEW_SHIPPING_ADDRESS                                       @"AOShippingAddressViewController"
#define VIEW_ADD_ADDRESS                                            @"AOAddAddressViewController"
#define VIEW_CHECK_OUT                                              @"AOCheckOutViewController"
#define VIEW_PAYMENT_CONFIRM                                        @"AOPaymentConfirmViewController"
#define VIEW_ORDER_DETAILS                                          @"AOOrderDetailsViewController"
#define VIEW_BANK_TRANSFER                                          @"AOBankTransferViewController"
#define VIEW_PAYPAL                                                 @"AOPaypalViewController"
#define VIEW_CREDIT_CARD                                            @"AOCreditCardViewController"

#define UNWIND_STORE_ADDRESS                                        @"unWindStoreAddress"
#define UNWIND_PAYMENT_CONFIRM                                      @"unWindPaymentConfirm"
#define UNWIND_SIGNUP                                               @"unWindSignup"
#define UNWIND_LOGOUT                                               @"unWindLogout"

#define UNWIND_CHECKOUT_CART                                        @"unWindCheckoutToCart"
#define UNWIND_BANK_TRANSFER_CART                                   @"unWindBankTransferToCart"
#define UNWIND_PAYPAL_CART                                          @"unWindPaypalToCart"
#define UNWIND_CREDIT_CART_CART                                     @"unWindCreditCardToCart"


#define MOBILE_LENGTH                                               10
#define SEGUE_NEW_IMAGE                                             @"segue_new_image"

#define LANGUAGE_ENGLISH                                            @"en"
#define LANGUAGE_ARABIAN                                            @"ar"

#define USER_SIGNUP                                                 @"signup"
#define USER_LOGIN                                                  @"login"
#define USER_LOGOUT                                                 @"logout"

#define USER_NONE                                                   @"none"

#define CATEGORY_OFFERS                                             NSLocalizedString(@"category_offers", "")
#define CATEGORY_EXCLUSIVE                                          NSLocalizedString(@"category_exclusive", "")
#define CATEGORY_MEN                                                NSLocalizedString(@"category_men", "")
#define CATEGORY_WOMEN                                              NSLocalizedString(@"category_women", "")
#define CATEGORY_BEST_SELLERS                                       NSLocalizedString(@"category_best_sellers", "")

#define CATEGORY_OUD_INCENSE                                        NSLocalizedString(@"category_oud_incense", "")
#define CATEGORY_PERFUMES                                           NSLocalizedString(@"category_perfumes", "")
#define CATEGORY_OIL_PERFUMES                                       NSLocalizedString(@"category_oil_perfumes", "")
#define CATEGORY_SPRAY_PERFUMES                                     NSLocalizedString(@"category_spary_perfumes", "")
#define CATEGORY_INTENSE_PERFUMES                                   NSLocalizedString(@"category_intense_perfumes", "")
#define CATEGORY_ACCESSORIES                                        NSLocalizedString(@"category_accessories", "")
#define CATEGORY_TODAY_DEALS                                        NSLocalizedString(@"category_today_deals", "")

#define SUBCATEGORY_MENS_COLLECTION                                 NSLocalizedString(@"subcategory_mens_collection", "")
#define SUBCATEGORY_WOMENS_COLLECTION                               NSLocalizedString(@"subcategory_womens_collection", "")
#define SUBCATEGORY_UNISEX_COLLECTION                               NSLocalizedString(@"subcategory_unisex_collection", "")
#define SUBCATEGORY_ORIENTAL_PERFUMES                               NSLocalizedString(@"subcategory_oriental_perfumes", "")
#define SUBCATEGORY_WESTERN_PERFUMES                                NSLocalizedString(@"subcategory_western_perfumes", "")
#define SUBCATEGORY_ORIENTAL_WESTERN                                NSLocalizedString(@"subcategory_oriental_western", "")

#define SUBCATEGORY_ARABIAN_OUD                                     NSLocalizedString(@"subcategory_arabian_oud", "")
#define SUBCATEGORY_ARABIAN_MAJOON                                  NSLocalizedString(@"subcategory_arabian_majoon", "")
#define SUBCATEGORY_ARABIAN_MABTHOTH                                NSLocalizedString(@"subcategory_arabian_mabthoth", "")

#define SUBCATEGORY_DEHN_OUD                                        NSLocalizedString(@"subcategory_dehn_oud", "")
#define SUBCATEGORY_ARABIAN_BLENDS                                  NSLocalizedString(@"subcategory_arabian_blends", "")
#define SUBCATEGORY_AROMATIC_OILS                                   NSLocalizedString(@"subcategory_aromatic_oils", "")

#define CONTACT_MAIL                                                @"wecare@arabianoud.com"
#define CONTACT_PHONE                                               @"8001242030"
#define CONTACT_WHATSAPP                                            @"+966559774497"
#define COMPANY_NAME                                                @"Spelenzo"
#define ZIP_CODE                                                    @"11564"

#define CARD_APPLICATION_IDENTIFIER                                 @"Hyp------------------------------------------mcommerce"
#define CARD_PROFILE_TOKEN                                          @"bf1------------------------------------------51a8460d3"
#define CARD_APPLICATION_IDENTIFIER_FOR_SANDBOX                     @"gat------------------------------------------mcommerce"
#define CARD_PROFILE_TOKEN_FOR_SANDBOX                              @"904------------------------------------------0ed087504"

#define PAYPAL_CLIENT_ID_FOR_PRODUCTION                             @"Abb__fI4mshHP------------------------------------------SZrtTMrvkUJkkH-klS2DAJRc"
#define PAYPAL_CLIENT_ID_FOR_SANDBOX                                @"Abb__fI4mshHP------------------------------------------SZrtTMrvkUJkkH-klS2DAJRc"
#define PAYPAL_MERCHANT_NAME                                        @"Arabian Oud Company"
#define PAYPAL_MERCHANT_PRIVACY_POLICY_URL                          @"https://shop.arabianoud.com/index.php/privacy-policy/"
#define PAYPAL_MERCHANT_USER_AGREEMENT_URL                          @"https://shop.arabianoud.com/index.php/terms/"

#define PAYPAL_TAX                                                  @"0.0"
#define CURRENCY_CODE_PAYPAL                                        @"USD"
#define CURRENCY_CODE                                               NSLocalizedString(@"sar", "")
#define CURRENCY_RATE                                               3.75

#define SHARE_URL                                                   @"https://shop.arabianoud.com/index.php"

#define COUNTRY_EN                                                  @"Saudi Arabia"
#define COUNTRY_AR                                                  @"المملكة العربية السعودية"

#define PAYMENT_CASH                                                @"Cash on Delivery"
#define PAYMENT_BANK                                                @"Bank Transfer"
#define PAYMENT_PAYPAL                                              @"Paypal"
#define PAYMENT_CREDIT                                              @"Credit Card"
#define PAYMENT_CREDIT_VISA                                         @"Visa Card"
#define PAYMENT_CREDIT_MASTER                                       @"Master Card"

#define INVALID_COUPON_CODE                                         @"invalid_code"


// Shop API key

#define SHOP_ARABIANOUD_URL                                         @"https://shop.arabianoud.com/indexFun.php"
#define SHOP_ARABIANOUD_RESET_PASSWORD_URL                          @"https://shop.arabianoud.com/index.php/customer/account/resetpassword"

#define KEY_TAG                                                     @"tag"
#define KEY_CATEGORY                                                @"category"
#define KEY_ID                                                      @"id"
#define KEY_EMAIL                                                   @"email"
#define KEY_PASSWORD                                                @"password"
#define KEY_FIRST_NAME                                              @"firstname"
#define KEY_LAST_NAME                                               @"lastname"
#define KEY_NAME                                                    @"name"
#define KEY_IMAGE_STRING                                            @"imageString"
#define KEY_START_ID                                                @"startID"
#define KEY_LANGUAGE                                                @"language"

#define KEY_IS_DEFAULT                                              @"is_default"
#define KEY_FNAME                                                   @"fname"
#define KEY_LNAME                                                   @"lname"
#define KEY_STNAME                                                  @"stname"
#define KEY_STNUM                                                   @"stnum"
#define KEY_ADDINFO                                                 @"addinfo"
#define KEY_CITY                                                    @"city"
#define KEY_COMPANY                                                 @"company"
#define KEY_ZIP                                                     @"zip"
#define KEY_COUNTRY                                                 @"country"
#define KEY_TEL                                                     @"tel"
#define KEY_FAX                                                     @"fax"

#define KEY_IDS                                                     @"ids"
#define KEY_QTYS                                                    @"qtys"
#define KEY_TOTAL                                                   @"total"
#define KEY_SEARCH_KEY                                              @"searchKey"

#define TAG_GET_CATEGORIES                                          @"GetCategories"
#define TAG_GET_PRODUCTS                                            @"GetProducts"
#define TAG_GET_PRODUCT_BYID                                        @"GetProductByID"
#define TAG_LOGIN                                                   @"login"
#define TAG_REGISTER                                                @"register"
#define TAG_UPLOAD_IMAGE                                            @"uploadImage"
#define TAG_SAVE_IMAGE                                              @"saveImage"
#define TAG_DELETE_PROFILE                                          @"deleteProfile"
#define TAG_GET_MAIN_CATEGORIES                                     @"getMainCategories"
#define TAG_GET_SUB_CATEGORIES                                      @"getSubcategories"
#define TAG_LOCATIONS                                               @"locations"
#define TAG_GET_CATEGORY_PRODUCTS                                   @"getCategoryProducts"
#define TAG_SET_DEFAULT_SHIPPING_BILLING_ADDRESS                    @"setDefaultShippingBillingAddress"
#define TAG_GET_ALL_ADDRESSES                                       @"getAllAddresses"
#define TAG_ADD_TO_CART                                             @"addtocart"
#define TAG_DELETE_CART                                             @"deleteCart"
#define TAG_CHECKOUT                                                @"checkout"
#define TAG_BANK_TRANSFER                                           @"BankTransfer"
#define TAG_CREDIT_CARD                                             @"creditCard"
#define TAG_PAYPAL                                                  @"paypal"
#define TAG_GET_COUNTRIES                                           @"getCountries"
#define TAG_SEARCH_CATEGORY_PRODUCTS                                @"searchCategoryProducts"
#define TAG_SEARCH_ALL_PRODUCTS                                     @"searchAllProducts"
#define TAG_AUTO_COMPLETE                                           @"autocomplete"
#define TAG_PRODUCT_DATA                                            @"productData"
#define TAG_FORGET_PASSWORD                                         @"forgetPassword"
#define TAG_SET_COUPON_CODE                                         @"setCouponCode"
#define TAG_CREDIT_CARD_CHECKOUT                                    @"creditcardCheckout"
#define TAG_GET_PAYMENT_STATUS                                      @"getPaymentStatus"

#define KEY_SUCCESS                                                 @"success"
#define KEY_CUSTOMER_DATA                                           @"customerData"
#define KEY_PRODUCTS                                                @"products"
#define KEY_PRICE                                                   @"price"
#define KEY_DISCOUNT                                                @"discount"
#define KEY_DESCRIPTION                                             @"description"
#define KEY_IMAGE                                                   @"image"
#define KEY_PERCENTAGE                                              @"percentage"
#define KEY_URL                                                     @"url"
#define KEY_SKU                                                     @"sku"
#define KEY_SIZE                                                    @"size"
#define KEY_TYPE                                                    @"type"
#define KEY_ORIGIN                                                  @"origin"
#define KEY_FRAGRANCE                                               @"fragrance"
#define KEY_ADDRESSES                                               @"addresses"
#define KEY_ADDRESS                                                 @"address"

#define KEY_LOCATIONS                                               @"Locations"
#define KEY_DISPLAY_ADDRESS                                         @"displayaddress"
#define KEY_ZIP_CODE                                                @"zipcode"
#define KEY_STATE                                                   @"state"
#define KEY_COUNTRY_ID                                              @"country_id"
#define KEY_PHONE                                                   @"phone"
#define KEY_LAT                                                     @"lat"
#define KEY_LONG                                                    @"long"

#define KEY_COUPON_CODE                                             @"couponCode"
#define KEY_SHOPCART_NAME                                           @"shopcart_name"
#define KEY_SHOPCART_RULE                                           @"shopcart_rule"

#define KEY_CREDIT_CARD_CHECKOUT                                    @"creditcardCheckout"
#define KEY_AMOUNT                                                  @"amount"
#define KEY_RESULT                                                  @"result"
#define KEY_CODE                                                    @"code"

#define KEY_ORDER_ID                                                @"orderId"

#define CHECKED                                                     @"checked"
#define UNCHECKED                                                   @"unchecked"


// show SVProgressHUD

#define SVPROGRESSHUD_SHOW                                          [SVProgressHUD showWithStatus:NSLocalizedString(@"please_wait", "") maskType:SVProgressHUDMaskTypeClear]
#define SVPROGRESSHUD_WAIT(status)                                  [SVProgressHUD showWithStatus:status maskType:SVProgressHUDMaskTypeGradient]
#define SVPROGRESSHUD_DISMISS                                       [SVProgressHUD dismiss]
#define SVPROGRESSHUD_SUCCESS(status)                               [SVProgressHUD showSuccessWithStatus:status]
#define SVPROGRESSHUD_ERROR(status)                                 [SVProgressHUD showErrorWithStatus:status]
#define SVPROGRESSHUD_NETWORK_ERROR                                 [SVProgressHUD showErrorWithStatus:@"Connection error"]



#endif
