//
//  ViewController.h
//  AroundTestObjc
//
//  Created by Farzan on 9/3/18.
//  Copyright © 2018 Mevamedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EadsSDK/EadsSDK-Swift.h>

@interface ViewController : UIViewController <ARAdDelegate>

- (void)updateStatusLabel:(NSString *) text;

@end

