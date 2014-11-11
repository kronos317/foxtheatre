//
//  SocialViewController.h
//  BoulderTheater
//
//  Created by Mark Ferguson on 4/25/10.
//  Copyright 2010 Drive Thru Online, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SocialViewController : UIViewController <UIWebViewDelegate> {
	NSArray *tweets;
	NSArray *facebookEntries;
	NSInteger stopDownloadingImages;
	
	IBOutlet UIActivityIndicatorView *loader;
	IBOutlet UIButton *reloadButton;
	
	NSString *twitterString;
	NSString *facebookString;
	float currentFacebookY;
	
	IBOutlet UIWebView *externalWebView;
	IBOutlet UIButton *backButton;
	IBOutlet UIButton *webBackButton;
	IBOutlet UIButton *webForwardButton;	
	IBOutlet UIActivityIndicatorView *webLoader;
	
	IBOutlet UIView *popupLoader;
	IBOutlet UILabel *popupLoaderLabel;
	
	IBOutlet UIView *switchHolder;
	IBOutlet UIButton *twitterButton;	
	IBOutlet UIButton *facebookButton;	
	
	IBOutlet UIView *holderView;
	IBOutlet UIScrollView *twitterView;
	IBOutlet UIView *tweetsHolder;
	IBOutlet UIScrollView *facebookView;
	IBOutlet UIView *facebookHolder;
}

- (IBAction)switchAction:(id)sender;
- (void)twitterAction;
- (void)facebookAction;
- (void)resetView;

- (void)loadTwitterView;
- (void)loadFacebookView;

- (void)showPopupLoader:(NSString *)text;
- (void)hidePopupLoader;

- (void)showWebView:(NSString *)path;
- (IBAction)hideWebView;
- (void)showWebButtons;
- (void)hideWebButtons;
- (IBAction)backAction;

- (void)loadNewData;
- (void)refreshImageForTwitterItem:(NSDictionary *)d;
- (void)refreshImageForFacebookItem:(NSDictionary *)d;
- (void)loadTwitterImages;
- (void)loadFacebookImages;

- (NSString *)getTimeSince:(NSDate *)startDate;
- (NSString *)flattenHTML:(NSString *)html;

@end
