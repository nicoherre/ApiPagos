//
//  HTTPHandler.m
//  ApiPagos
//
//  Created by mlgw on 10/21/20.
//

#import "HTTPHandler.h"
#import "Constants.h"

@implementation HTTPHandler


+(void)requestContentFromURL:(NSString*)url_str withResponseBlock:(HttpClientResponseBlock)responseBlock{
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url_str]];
    [urlRequest setHTTPMethod:@"GET"];
    [urlRequest setValue:AUTHORIZATION_BEARER forHTTPHeaderField:@"Authorization"];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if(httpResponse.statusCode == 200)
        {
            id json = [NSJSONSerialization JSONObjectWithData:data
                                                      options:NSJSONReadingAllowFragments
                                                        error:&error];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                responseBlock(urlRequest, json, error);
            }];
        }
        else
        {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                responseBlock(urlRequest, nil, error);
            }];
        }
    }];
    [dataTask resume];
    
}
@end
