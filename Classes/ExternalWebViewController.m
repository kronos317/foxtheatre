//
//  ExternalWebViewController.m
//  eTown
//
//  Created by Keiran on 8/14/12.
//  Copyright (c) 2012 Rage Digital. All rights reserved.
//

#import "ExternalWebViewController.h"

@interface ExternalWebViewController ()

@end

@implementation ExternalWebViewController

@synthesize rootURL=_rootURL;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
//	self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header_logo.png"]];
	
//	webView.frame = CGRectMake(0,44,320,self.view.frame.size.height - 137);
	
	[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_rootURL]]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if(buttonIndex != actionSheet.cancelButtonIndex)
		[[UIApplication sharedApplication] openURL:webView.request.URL];
}


#pragma mark - Web View

- (IBAction)outputAction:(id)sender {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:webView.request.URL.absoluteString delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Open in Safari", nil];
	[actionSheet showFromTabBar:self.navigationController.tabBarController.tabBar];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
	webLoader.hidden = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	webLoader.hidden = YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	webLoader.hidden = YES;
}


#pragma mark -

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
