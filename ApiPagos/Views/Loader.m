//
//  Loader.m
//  ApiPagos
//
//  Created by mlgw on 10/24/20.
//

#import "Loader.h"

@implementation Loader


-(id)initWithParent:(UIView*)view{
    self = [super init];
    if(self){
        float container_size = 60;
        float loader_size = container_size / 2.0;
        self.loader_container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, container_size, container_size)];
        self.loader_container.layer.cornerRadius = 10;
        [self.loader_container setCenter:view.center];
        self.loader_container.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        self.loader = [[UIImageView alloc] initWithFrame:CGRectMake((self.loader_container.frame.size.width - loader_size)/2.0, (self.loader_container.frame.size.height - loader_size)/2.0, loader_size, loader_size)];
        [self.loader_container addSubview:self.loader];
        [view addSubview:self.loader_container];
        [self.loader_container setHidden:YES];
    }
    return self;
}


-(void)showLoading{
    if ([self.loader_container isHidden]) {
        [self.loader_container setAlpha:0];
        self.loader_container.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.3, 0.3);
        [self.loader_container setHidden:NO];
        [self animateLoader];
        

        [UIView animateWithDuration:0.3 animations:^{
            [self.loader_container setAlpha:1];
            self.loader_container.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
        } completion:^(BOOL finished) {}];
        
    }
}

-(void)hideLoading{
    if([self.loader_container isHidden]){
        return;
    }
    
    [self.loader stopAnimating];
    [UIView animateWithDuration:0.2 animations:^{
        [self.loader_container setAlpha:0];
        self.loader_container.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.3, 0.3);
    } completion:^(BOOL finished) {
        [self.loader_container setHidden:YES];
    }];
}


-(void)animateLoader{
    
    self.loader.image = [UIImage imageNamed:@"Spinning-zen"];
    
    self.loader.image = [self.loader.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.loader setTintColor:[UIColor whiteColor]];
    
    self.loader.hidden = NO;
    
    CABasicAnimation *rotation;
    rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotation.fromValue = [NSNumber numberWithFloat:0];
    rotation.toValue = [NSNumber numberWithFloat:(2 * M_PI)];
    rotation.duration = 1.0;
    rotation.repeatCount = HUGE_VALF;
    [self.loader.layer addAnimation:rotation forKey:@"Spin"];
}


@end
