//
//  UIImageView+URL.m
//  ApiPagos
//
//  Created by mlgw on 10/24/20.
//

#import "UIImageView+Url.h"

@implementation UIImageView (Url)

- (void)setImageWithUrl:(NSURL *)url{
    if (url)
    {
        NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithURL:url
                                                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
        {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (!error && NSLocationInRange(httpResponse.statusCode, NSMakeRange(200, 99)))
            {
                UIImage *image = [UIImage imageWithData:data];
                if (image)
                {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        [self setImageWithAnimation:image];
                    }];
                }
            }
        }];
        
        [dataTask resume];
    }
}


-(void)setImageWithAnimation:(UIImage*)img{
    self.alpha = 0;
    [self setImage:img];
    [UIView animateWithDuration:0.5 animations:^{
        [self setAlpha:1];
    }];
}

@end
