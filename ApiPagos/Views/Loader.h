//
//  Loader.h
//  ApiPagos
//
//  Created by mlgw on 10/24/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Loader : NSObject
@property (nonatomic, strong) UIView* loader_container;
@property (nonatomic, strong) UIImageView* loader;

-(id)initWithParent:(UIView*)view;
-(void)showLoading;
-(void)hideLoading;

@end

NS_ASSUME_NONNULL_END
