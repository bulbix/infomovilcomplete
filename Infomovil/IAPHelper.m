//
//  IAPHelper.m
//  In App Rage
//
//  Created by Ray Wenderlich on 9/5/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

// 1
#import "IAPHelper.h"
#import <StoreKit/StoreKit.h>

NSString *const IAPHelperProductPurchasedNotification = @"IAPHelperProductPurchasedNotification";

// 2
@interface IAPHelper () <SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
    NSString *productoAComprar;
}
@end

// 3
@implementation IAPHelper {
    SKProductsRequest * _productsRequest;
    RequestProductsCompletionHandler _completionHandler;
    
    NSSet * _productIdentifiers;
    NSMutableSet * _purchasedProductIdentifiers;
}

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers {
    if ((self = [super init])) {
        productoAComprar = nil;
        _productIdentifiers = productIdentifiers;
        _purchasedProductIdentifiers = [NSMutableSet set];
        for (NSString * productIdentifier in _productIdentifiers) {
            BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
            if (productPurchased) {
                [_purchasedProductIdentifiers addObject:productIdentifier];
#if DEBUG
                NSLog(@"Previously purchased: %@", productIdentifier);
#endif
            } else {
#if DEBUG
                NSLog(@"Not purchased: %@", productIdentifier);
#endif
            }
        }
        
        // Add self as transaction observer
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
    }
    return self;
    
}


- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler {
    _completionHandler = [completionHandler copy];
    _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];
    _productsRequest.delegate = self;
    [_productsRequest start];
    
}

- (BOOL)productPurchased:(NSString *)productIdentifier {
    return [_purchasedProductIdentifiers containsObject:productIdentifier];
}

- (void)buyProduct:(SKProduct *)product {
#if DEBUG
    NSLog(@"El producto que se envío a comprar es: %@...", product.productIdentifier);
#endif
    productoAComprar = product.productIdentifier;
    SKPayment * payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
}

#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    _productsRequest = nil;
    self.datosUsuario = [DatosUsuario sharedInstance];
    NSArray * skProducts = response.products;
   
    NSUserDefaults *prefSesion = [NSUserDefaults standardUserDefaults];
    for (SKProduct * skProduct in skProducts) {
        NSLog(@"Found product en IAPHelper: %@ %@ %0.2f",
              skProduct.productIdentifier,
              skProduct.localizedTitle,
              skProduct.price.floatValue);
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [numberFormatter setLocale:skProduct.priceLocale];
        NSLocale* storeLocale = skProduct.priceLocale;
        NSString *storeCountry = (NSString*)CFLocaleGetValue((CFLocaleRef)storeLocale, kCFLocaleCountryCode);
        NSLog(@"EL PAIS ES: %@", storeCountry);
        if([skProduct.productIdentifier isEqualToString:@"com.infomovil.infomovil.12_months_new"]){
            if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
                [prefSesion setObject:[NSString stringWithFormat:@"%0.2f / month",  skProduct.price.floatValue/12] forKey:@"precioDoceMesesPlanPro"];
            }else{
                [prefSesion setObject:[NSString stringWithFormat:@"%0.2f x mes",  skProduct.price.floatValue/12] forKey:@"precioDoceMesesPlanPro"];
            }
        }else if([skProduct.productIdentifier isEqualToString:@"com.infomovil.infomovil.1_month"]){
            if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
                [prefSesion setObject:[NSString stringWithFormat:@"%0.2f / month",  skProduct.price.floatValue] forKey:@"precioUnMesPlanPro"];
            }else{
                [prefSesion setObject:[NSString stringWithFormat:@"%0.2f x mes",  skProduct.price.floatValue] forKey:@"precioUnMesPlanPro"];
            }
        }else if([skProduct.productIdentifier isEqualToString:@"com.infomovil.infomovil.dominiotel"]){
            if([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location != NSNotFound){
                [prefSesion setObject:[NSString stringWithFormat:@"%0.2f / month",  skProduct.price.floatValue] forKey:@"precioUnMesPlanPro"];
            }else{
                [prefSesion setObject:[NSString stringWithFormat:@"%0.2f x mes",  skProduct.price.floatValue] forKey:@"precioUnMesPlanPro"];
            }
        }
        [prefSesion synchronize];
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"PreciosPlanPro" object:self];
    if ([CommonUtils hayConexion]) {
        if([skProducts count] > 0){
            if(_completionHandler)
            {
                _completionHandler(YES, skProducts);
            }
        }
    }
    _completionHandler = nil;
    
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"cancelo la transacción!!");
    _productsRequest = nil;
    _completionHandler(NO, nil);
    _completionHandler = nil;
    if([productoAComprar isEqualToString:@"com.infomovil.infomovil.dominiotel"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FailedTransactionNotificationDominio" object:self];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FailedTransactionNotification" object:self];
    
    }
}

#pragma mark SKPaymentTransactionOBserver

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction * transaction in transactions) {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
               
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
              
            default:
                break;
        }
    };
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
     [self provideContentForProductIdentifier:transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    if([productoAComprar isEqualToString:@"com.infomovil.infomovil.dominiotel"]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CompleteTransactionNotificationDominio" object:self];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CompleteTransactionNotification" object:self];
    }
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    [self provideContentForProductIdentifier:transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {

    if(transaction.error.localizedDescription == nil || [transaction.error.localizedDescription isEqualToString:@""] || [transaction.error.localizedDescription length] <= 0){
        AlertView *alertaError = [AlertView initWithDelegate:self titulo:NSLocalizedString(@"sentimos", Nil) message:NSLocalizedString(@"errorCompra", Nil) dominio:Nil andAlertViewType:AlertViewTypeInfo];
        [alertaError show];
    }else if((long)transaction.error.code == 2){
#if DEBUG
        NSLog(@"Transaction error: %@ con codigo %ld", transaction.error.localizedDescription, (long)transaction.error.code);
#endif
    }else{
        AlertView *alertaError = [AlertView initWithDelegate:self titulo:NSLocalizedString(@"sentimos", Nil) message:transaction.error.localizedDescription dominio:Nil andAlertViewType:AlertViewTypeInfo];
        [alertaError show];
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
     if([productoAComprar isEqualToString:@"com.infomovil.infomovil.dominiotel"]){
         [[NSNotificationCenter defaultCenter] postNotificationName:@"FailedTransactionNotificationDominio" object:self];
     }else{
          [[NSNotificationCenter defaultCenter] postNotificationName:@"FailedTransactionNotification" object:self];
     }
}

- (void)provideContentForProductIdentifier:(NSString *)productIdentifier {
    
    [_purchasedProductIdentifiers addObject:productIdentifier];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductPurchasedNotification object:productIdentifier userInfo:nil];
    
}

- (void)restoreCompletedTransactions {
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

@end