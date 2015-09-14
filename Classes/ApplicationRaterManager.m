//
//  ApplicationRaterDelegate.h
//
//
//  Created by Raphael Pinto on 12/02/2014.
//
// The MIT License (MIT)
// Copyright (c) 2014 Raphael Pinto.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import "ApplicationRaterManager.h"
#import "ApplicationRaterDelegate.h"



@implementation ApplicationRaterManager



static ApplicationRaterManager *sharedInstance = nil;



#pragma mark -
#pragma mark Object Life Cycle Methods



+ (ApplicationRaterManager*)sharedRatingManager
{
	if (sharedInstance == nil)
	{
		sharedInstance = [[ApplicationRaterManager alloc] init];
	}
	
	return sharedInstance;
}


+ (void)releaseSharedRatingManager
{
	if (sharedInstance != nil)
	{
		[sharedInstance release];
		sharedInstance = nil;
	}
}



#pragma mark -
#pragma mark Manager Life Cycle Methods



- (void)dealloc
{
    [super dealloc];
}



#pragma mark -
#pragma mark Rating Manager Methods



- (void)displayStoreProductViewControllerForAppId:(NSNumber*)_AppId onViewController:(UIViewController*)_UIViewController
{
    [self displayStoreProductViewControllerForAppId:_AppId onViewController:_UIViewController withDelegate:nil];
}


- (void)displayStoreProductViewControllerForAppId:(NSNumber*)_AppId onViewController:(UIViewController*)_UIViewController withDelegate:(NSObject<ApplicationRaterDelegate>*)_Delegate
{
    self.mDelegate = _Delegate;
    
    SKStoreProductViewController *storeViewController = [[SKStoreProductViewController alloc] init];
    
    [storeViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:_AppId} completionBlock:nil];
    storeViewController.delegate = self;
    
    [_UIViewController presentViewController:storeViewController animated:YES completion:nil];
}



#pragma mark -
#pragma mark Store Kit Delegate Methods



- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
	[viewController dismissViewControllerAnimated:YES completion:nil];

    
    if (self.mDelegate)
    {
        [self.mDelegate applicationRaterDidFinish:self];
    }
    
    [ApplicationRaterManager releaseSharedRatingManager];
}


@end
