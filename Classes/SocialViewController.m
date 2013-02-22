//
//  SocialViewController.m
//  BoulderTheater
//
//  Created by Mark Ferguson on 4/25/10.
//  Copyright 2010 Rage Digital Inc. All rights reserved.
//

#import "SocialViewController.h"
#import "JSON.h"
//#import "AFHTTPClient.h"
//#import "UIImageView+AFNetworking.h"
#import "ExternalWebViewController.h"

#define facebookURL @"http://m.facebook.com/foxtheatreboulder"
#define twitterURL @"https://mobile.twitter.com/foxtheatreco"

@implementation SocialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
//	self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header_logo.png"]];
	
	facebookWebView.frame = CGRectMake(-320,facebookWebView.frame.origin.y,320,facebookWebView.frame.size.height);
	twitterWebView.frame = CGRectMake(0,twitterWebView.frame.origin.y,320,twitterWebView.frame.size.height);
	
	[self reloadContent];
}

- (void)showExternalWebView:(NSString*)url {
	ExternalWebViewController *webViewVC = [[ExternalWebViewController alloc] init];
	[webViewVC setRootURL:url];
}


#pragma mark - Data

- (void)reloadContent {
	[facebookWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:facebookURL]]];
	[twitterWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:twitterURL]]];
}


#pragma mark - Display

- (IBAction)switchAction:(id)sender {

	if((UIButton *) sender == twitterButton) {
		// Twitter button was pressed
		[twitterButton setBackgroundImage:[UIImage imageNamed:@"toggleLeft_on.png"] forState:UIControlStateNormal];
		[facebookButton setBackgroundImage:[UIImage imageNamed:@"toggleRight.png"] forState:UIControlStateNormal];
//		[self twitterAction];
	}
	else {
		// Facebook button was pressed
		[twitterButton setBackgroundImage:[UIImage imageNamed:@"toggleLeft.png"] forState:UIControlStateNormal];
		[facebookButton setBackgroundImage:[UIImage imageNamed:@"toggleRight_on.png"] forState:UIControlStateNormal];
//		[self facebookAction];
	}
	
	[UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
					 animations:^{
						 if(sender == facebookButton) {
							 facebookWebView.frame = CGRectMake(0,facebookWebView.frame.origin.y,320,facebookWebView.frame.size.height);
							 twitterWebView.frame = CGRectMake(320,twitterWebView.frame.origin.y,320,twitterWebView.frame.size.height);
						 } else {
							 facebookWebView.frame = CGRectMake(-320,facebookWebView.frame.origin.y,320,facebookWebView.frame.size.height);
							 twitterWebView.frame = CGRectMake(0,twitterWebView.frame.origin.y,320,twitterWebView.frame.size.height);
						 }
					 }
					 completion:^(BOOL finished){
						 
					 }
	 ];
}


#pragma mark -
#pragma mark WebView

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	NSLog(@"%@",[request.URL absoluteString]);
	if([[request.URL absoluteString] isEqualToString:@"about:blank"] || [[request.URL absoluteString] isEqualToString:facebookURL] || [[request.URL absoluteString] isEqualToString:twitterURL]) {
		return YES;
	} else {
		NSRange range = [[request.URL absoluteString] rangeOfString:@"https://mobile.twitter.com/i/templates/"];
		if(range.location == NSNotFound) {
			[self showExternalWebView:request.URL.absoluteString];
			return NO;
		} else {
			return YES;
		}
	}
}


#pragma mark -

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)dealloc {
    [facebookWebView release];
    [twitterWebView release];
    [super dealloc];
}


@end
