//
//  InfoViewController.h
//  VenueConnect
//
//  Created by Keiran on 11/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MessageUI/MessageUI.h>

@interface InfoViewController : UIViewController <UIScrollViewDelegate,MKMapViewDelegate,UIAlertViewDelegate,MFMessageComposeViewControllerDelegate, UINavigationControllerDelegate> {
	IBOutlet UIScrollView *mainView;
	IBOutlet MKMapView *mapView;
	IBOutlet UIButton *backButton;
	
	IBOutlet UIButton *boxCallButton;
	IBOutlet UIButton *mainCallButton;
	
	IBOutlet UIButton *urlVisitButton;
	IBOutlet UIWebView *webView;
	IBOutlet UIButton *webBackButton;
	IBOutlet UIButton *webForwardButton;
	IBOutlet UIActivityIndicatorView *webLoader;	
}

- (void)hideBackButton;
- (void)showBackButton;

- (IBAction)callNumber:(id)sender;
- (IBAction)showMap;
- (void)placePinsOnMap;

- (IBAction)visitWebsite:(id)sender;
- (void)showWebButtons;
- (void)hideWebButtons;

- (IBAction)backAction;

@end
