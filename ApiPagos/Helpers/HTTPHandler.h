//
//  HTTPHandler.h
//  ApiPagos
//
//  Created by mlgw on 10/21/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^HttpClientResponseBlock)(NSURLRequest *request, id _Nullable json, NSError * _Nullable error);

@interface HTTPHandler : NSObject

+(void)requestContentFromURL:(NSString*)url_str withResponseBlock:(HttpClientResponseBlock)response;

@end

NS_ASSUME_NONNULL_END
