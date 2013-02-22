//
//  ExternalWebViewController.h
//  eTown
//
//  Created by Keiran on 8/14/12.
//  Copyright (c) 2012 Rage Digital. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExternalWebViewController : UIViewController <UIWebViewDelegate,UIActionSheetDelegate> {
	IBOutlet UIWebView *webView;
	
	IBOutlet UIActivityIndicatorView *webLoader;
}

- (IBAction)outputAction:(id)sender;

@property (nonatomic,strong) NSString *rootURL;

@end
