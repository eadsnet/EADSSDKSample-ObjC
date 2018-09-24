//
//  ViewController.m
//  AroundTestObjc
//
//  Created by Farzan on 9/3/18.
//  Copyright © 2018 Mevamedia. All rights reserved.
//

#import "ViewController.h"
#import <EadsSDK/EadsSDK-Swift.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *sdkModeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sdkTokenLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (nonatomic, strong) ARNativeBannerView *nativeBannerAd;
@property (nonatomic, strong) ARNativeVideoAd *nativeVideoBannerAd;

@end

@implementation ViewController

- (IBAction)clearClicked:(UIButton *)sender {
    _statusLabel.text = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _sdkModeLabel.text = (EadsAd.config.environment == AREnvironmentSandbox) ? @"Sandbox" : @"Production";
    _sdkTokenLabel.text = EadsAd.config.appToken;
    self.view.backgroundColor = [[UIColor alloc] initWithWhite:0.95 alpha:1];
}

// MARK: Add Advertise Banners

- (IBAction)initiateNativeBannerAd:(UIButton *)sender {
    if (_nativeBannerAd) {
        [sender setTitle:@"Native Banner" forState: UIControlStateNormal];
        [_nativeBannerAd removeFromSuperview];
        _nativeBannerAd = NULL;
        return;
    }
    [sender setTitle:@"Dismiss Native Banner" forState: UIControlStateNormal];
    _nativeBannerAd = [[ARNativeBannerView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 320)/2, self.view.frame.size.height - 100, 320, 50) size:ARBannerSizeBANNER_320x50 zone:ZoneAll];
    _nativeBannerAd.delegate = self;
    [self.view addSubview:_nativeBannerAd];
    [_nativeBannerAd execute];
    [self updateStatusLabel:[NSString stringWithFormat:@"%@ is fetching", NSStringFromClass([_nativeBannerAd class])]];

    _nativeBannerAd.clicked = ^{
        NSLog(@"Native banner clicked.");
    };
}

- (IBAction)initiateFullScreenNativeBannerAd:(UIButton *)sender {
    ARFullscreenBannerView *banner = [[ARFullscreenBannerView alloc] initWithZone:ZoneAll];
    banner.delegate = self;
    [banner execute];
    [self updateStatusLabel:[NSString stringWithFormat:@"%@ is fetching", NSStringFromClass([banner class])]];

    banner.clicked = ^{
        NSLog(@"Fullscreen banner clicked.");
    };
}

- (IBAction)initiateNativeVideoBannerAd:(UIButton *)sender {
    if (_nativeVideoBannerAd) {
        [sender setTitle:@"Native Video Banner" forState: UIControlStateNormal];
        [_nativeVideoBannerAd removeFromSuperview];
        _nativeVideoBannerAd = NULL;
        return;
    }
    [sender setTitle:@"Dismiss Native Video Banner" forState: UIControlStateNormal];
    _nativeVideoBannerAd = [[ARNativeVideoAd alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 250, self.view.frame.size.width, 250) zone:ZoneAll cache:FALSE];
    _nativeVideoBannerAd.delegate = self;
    [self.view addSubview:_nativeVideoBannerAd];
    [_nativeVideoBannerAd execute];
    [self updateStatusLabel:[NSString stringWithFormat:@"%@ is fetching", NSStringFromClass([_nativeVideoBannerAd class])]];
    
    _nativeVideoBannerAd.clicked = ^{
        NSLog(@"Video banner clicked.");
    };
}

- (IBAction)initiateFullscreenNativeVideoBannerAd:(UIButton *)sender {
    ARFullscreenVideoAd *banner = [[ARFullscreenVideoAd alloc] initWithZone:ZoneAll cache:FALSE];
    banner.delegate = self;
    [banner execute];
    [self updateStatusLabel:[NSString stringWithFormat:@"%@ is fetching", NSStringFromClass([banner class])]];
    
    banner.clicked = ^{
        NSLog(@"Fullscreen video banner clicked.");
    };
    
    banner.viewCompleted = ^{
        NSLog(@"Fullscreen video banner content did finish displaying.");
    };
}

- (void)updateStatusLabel:(NSString *)text {
    self.statusLabel.text = [NSString stringWithFormat:@"%@ \n --------- \n %@", text, self.statusLabel.text];
}

// ARAdDelegate for implemented adviews in viewcontroller


- (void)eadsAd:(ARAdView * _Nonnull)adView ARAdDidFinishLoadWithTag:(NSInteger)tag contentAvailable:(BOOL)contentAvailable {
    [self updateStatusLabel:[NSString stringWithFormat:@"%@ did finished loading with content: %d", NSStringFromClass([adView class]), contentAvailable]];
}

- (void)eadsAd:(ARAdView * _Nonnull)adView didCompleteWithError:(enum SplitError)error {
    NSString *errorText;
    switch (error) {
        case SplitErrorForbidden:
            errorText = @"Forbidden";
            break;
        case SplitErrorServerError:
            errorText = @"Internal Server Error";
            break;
        case SplitErrorNetworkError:
            errorText = @"Network Error";
            break;
        case SplitErrorNoInternetConnection:
            errorText = @"No Internet Connection";
            break;
    }
    [self updateStatusLabel:[NSString stringWithFormat:@"%@ did Complete with error: %@", NSStringFromClass([adView class]), errorText]];
}

- (void)eadsAd:(ARAdView * _Nonnull)adView didDismissWithTag:(NSInteger)tag {
    [self updateStatusLabel:[NSString stringWithFormat:@"%@ did dismiss", NSStringFromClass([adView class])]];
}

- (BOOL)eadsAd:(ARAdView * _Nonnull)adView willDismissWithTag:(NSInteger)tag {
    [self updateStatusLabel:[NSString stringWithFormat:@"%@ will dismiss", NSStringFromClass([adView class])]];
    
    if ([adView isKindOfClass:[ARFullscreenVideoAd class]]) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Warning"
                                                                       message:@"You should see the Ad to get rewarded, Do you want to dismiss the Ad?"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Continue" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
            [adView dismissWithAnimatoin:TRUE];
        }]];
        [self presentViewController:alert animated:YES completion:nil];

        return FALSE;
    } else {
        return TRUE;
    }

}

@end


